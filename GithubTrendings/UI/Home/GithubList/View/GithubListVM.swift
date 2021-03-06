//
//  GithubListVm.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private typealias Interval = GithubDataProvider.Interval

class GithubListVM: ViewModel {
    private let dataProvider: GithubDataProvider
    private let udManager: UDManager

    fileprivate lazy var lastDayRepos = BehaviorRelay<[Repo]>(value: [])
    fileprivate lazy var lastWeekRepos = BehaviorRelay<[Repo]>(value: [])
    fileprivate lazy var lastMonthRepos = BehaviorRelay<[Repo]>(value: [])

    fileprivate let segmentSwitched = PublishSubject<Int>()
    fileprivate let selected = PublishSubject<Int>()
    fileprivate let loadNext = PublishSubject<Void>()
    fileprivate let showDetail = PublishSubject<Repo>()

    private let currentInterval = BehaviorRelay<Interval>(value: .day)

    fileprivate let todayCells = BehaviorRelay<[Cell]>(value: [])
    fileprivate let lastWeekCells = BehaviorRelay<[Cell]>(value: [])
    fileprivate let lastMonthCells = BehaviorRelay<[Cell]>(value: [])

    init(dataProvider: GithubDataProvider, udManager: UDManager) {
        self.dataProvider = dataProvider
        self.udManager = udManager

        super.init()

        bindInput()
        bindOutput()

        // run initial values
        dataProvider.loadRepos(for: .day, page: 0, perPage: 20)
            .bind(to: lastDayRepos)
            .disposed(by: bag)

        dataProvider.loadRepos(for: .week, page: 0, perPage: 20)
            .bind(to: lastWeekRepos)
            .disposed(by: bag)

        dataProvider.loadRepos(for: .month, page: 0, perPage: 20)
            .bind(to: lastMonthRepos)
            .disposed(by: bag)
    }

    private func bindOutput() {
        let mapCell: ([Repo], Set<Repo>) -> [Cell] = { [weak self] dto, saved -> [Cell] in
            guard let self = self else { return [] }
            return dto.map { repo in
                let cell = Cell(
                    title: repo.owner.login + "/" + repo.name,
                    subtitle: repo.description,
                    bookmarked: saved.contains(repo),
                    avatarUrl: repo.owner.avatarUrl
                )

                cell.bookmarkSubject
                    .withLatestFrom(self.udManager.reposRelay)
                    .map {
                        var saved = $0
                        if saved.contains(repo) {
                            saved.remove(repo)
                        } else {
                            saved.insert(repo)
                        }
                        return saved
                    }
                    .bind(to: self.udManager.reposRelay)
                    .disposed(by: cell.bag)

                return cell
            }
        }

        Observable.combineLatest(lastDayRepos, udManager.reposRelay)
            .map(mapCell)
            .bind(to: todayCells)
            .disposed(by: bag)

        Observable.combineLatest(lastWeekRepos, udManager.reposRelay)
            .map(mapCell)
            .bind(to: lastWeekCells)
            .disposed(by: bag)

        Observable.combineLatest(lastMonthRepos, udManager.reposRelay)
            .map(mapCell)
            .bind(to: lastMonthCells)
            .disposed(by: bag)
    }


    private func bindInput() {
        segmentSwitched
            .skip(1)
            .map { Interval.allCases[$0] }
            .bind(to: currentInterval)
            .disposed(by: bag)

        loadNext
            .skip(1) // we start with initial values, no need to loadNext on first run
            .withLatestFrom(Observable.combineLatest(currentInterval,lastDayRepos, lastMonthRepos, lastWeekRepos))
            .flatMap { [unowned self] interval, day, month, week -> Observable<[Repo]> in
                switch interval {
                case .day:
                    return self.dataProvider.loadRepos(for: interval, page: day.count / 20, perPage: 20)
                case .month:
                    return self.dataProvider.loadRepos(for: interval, page: month.count / 20, perPage: 20)
                case .week:
                    return self.dataProvider.loadRepos(for: interval, page: week.count / 20, perPage: 20)
                }
            }
            .subscribe(onNext: { [weak self] repo in
                guard let self = self else { return }
                switch self.currentInterval.value {
                    case .day:
                        self.lastDayRepos.accept(self.lastDayRepos.value + repo)
                    case .month:
                        self.lastMonthRepos.accept(self.lastMonthRepos.value + repo)
                    case .week:
                        self.lastWeekRepos.accept(self.lastWeekRepos.value + repo)
                }
            })
            .disposed(by: bag)

        selected
            .withLatestFrom(Observable.combineLatest(currentInterval,lastDayRepos, lastMonthRepos, lastWeekRepos)) { ($0, $1) }
            .map { (index, arg1) -> Repo in
                let (interval, day, month, week) = arg1
                switch interval {
                case .day:
                    return day[index]
                case .month:
                    return month[index]
                case .week:
                    return week[index]
                }
            }
            .bind(to: showDetail)
            .disposed(by: bag)
    }
}

extension GithubListVM {
    struct Cell: RepoTableCellLoadable {
        let title: String
        let subtitle: String?
        let bookmarked: Bool
        let avatarUrl: String

        let bookmarkSubject = PublishSubject<Void>()
        let bag = DisposeBag()
    }
}

extension Reactive where Base == Inputs<GithubListVM> {
    var segmentSwitched: AnyObserver<Int> { base.vm.segmentSwitched.asObserver() }
    var selected: AnyObserver<Int> { base.vm.selected.asObserver() }
    var loadNext: AnyObserver<Void> { base.vm.loadNext.asObserver() }
}

extension Reactive where Base == Outputs<GithubListVM> {
    var todayCells: Driver<[GithubListVM.Cell]> { base.vm.todayCells.asDriver(onErrorJustReturn: []) }
    var lastWeekCells: Driver<[GithubListVM.Cell]> { base.vm.lastWeekCells.asDriver(onErrorJustReturn: []) }
    var lastMonthcells: Driver<[GithubListVM.Cell]> { base.vm.lastMonthCells.asDriver(onErrorJustReturn: []) }
    var showDetail: Observable<Repo> { base.vm.showDetail.asObservable() }
}

extension Outputs where Base == GithubListVM {
    var title: String { return "repositories".localized }
    var segments: [String] { return Interval.allCases.map { $0.localizedTitle }  }
}
