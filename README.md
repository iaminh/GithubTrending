# GithubTrending iOS app
### Trending Repositories:
​
Create an iOS application that displays the most **trending repositories on GitHub** that were created in the _last day_, _last week_ and _last month_. The user should be able to choose which timeframe they want to view. In the same screen, the list of trending repositories sorted by the number of stars should be shown in a `UICollectionView`.
​
Each cell (repository) on the list should contain the following information:
​
* The username of the owner and the name of the repository (`owner->login` and `name` fields in the API response)
* The avatar of the owner as a small thumbnail (`owner->avatar_url` field). If no avatar exists, use a default "no avatar" image.
* The description for the repository (`description` field). if there is no description, add some default text to imply that.
* The number of stars (`stargazers_count` field)
​
#### Additional Features
​
* The list should allow for infinite scrolling, loading more items when the user reaches the end (or near it, for optimization)
* When a user taps on a cell, present a detail screen for the repository (could be full screen or modal, your choice), with all the former details and these additional ones:
    * Language, if available (`language` field)
    * Number of forks (`forks` field)
    * Creation date (`created_at` field)
    * a working link to the GitHub page of the repository (`html_url` field)
* The user should be able to add a repository to their own favourite list. The favourites repositories are saved locally and are available offline. There should be a Favorite Repositories screen that allows a user to view the favourite repositories, get their details and delete them. Favourited repositories should be shown as such in the main list.

## Architecture
**MVVM** with **Coordinators** in combination with reactive programming using **RxSwift**

### Pros:
- Scalability, testability, modularity, declarative approach
- Reactive programming is the future of iOS development (*SwiftUI, Combine*)
### Cons:
- Learning curve, overusing leads to hard debugging

## What could be improved
 - Missing error handlings
 - More user friendly empty states (Empty tableviews, empty texts)
 - UI (asssets weren't provided, only png of the screens)
 - Consider using proper persistance CoreData/Realm
 - Unit/UI tests
 - Swiftgen for assets(localization strings, images)
 - Dependency injection library
 - ipad optimalizations

## Final words
- This should serve as a showcase of my general coding style and architectural selection. Not as an example of a production ready app.
