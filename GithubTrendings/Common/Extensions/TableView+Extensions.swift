//
//  TableView+Extensions.swift
//  TVShow
//
//  Created by Chu Anh Minh on 5/27/19.
//  Copyright © 2019 MinhChu. All rights reserved.
//

import UIKit

public extension UIView {
    static var autoReuseIdentifier: String {
        return NSStringFromClass(self) + "AutogeneratedIdentifier"
    }
}

public extension UITableView {
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.autoReuseIdentifier, for: indexPath) as? T else {
            fatalError("Unknown cell")
        }
        return cell
    }

    func dequeueHeaderFooterView<T: UIView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.autoReuseIdentifier) as? T else {
            fatalError()
        }
        return view
    }

    func registerCell<T: UITableViewCell>(_ cell: T.Type) {
        register(nibFromClass(cell), forCellReuseIdentifier: cell.autoReuseIdentifier)
    }

    func registerSectionHeaderFooter<T: UIView>(_ view: T.Type) {
        register(nibFromClass(view), forHeaderFooterViewReuseIdentifier: view.autoReuseIdentifier)
    }

    // Private

    fileprivate func nibFromClass(_ type: UIView.Type) -> UINib? {
        guard let nibName = NSStringFromClass(type).components(separatedBy: ".").last
            else {
                return nil
        }

        return UINib(nibName: nibName, bundle: nil)
    }
}