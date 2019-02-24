# iMusic

## 🚨 Important note 🚨

This project is using cocoapods and the pods are included in the repo. Anyway if you have any problem please run the **pod install** command.

If you have any doubt about cocoapods you can check the reference [here](https://cocoapods.org).

## Project Architecture 
![alt tag](https://github.com/rcasanovan/iMusic/blob/master/Images/projectArchitecture.jpeg?raw=true)

References:
* [Viper architecture](https://www.objc.io/issues/13-architecture/viper/)
* [Viper for iOS](https://medium.com/@smalam119/viper-design-pattern-for-ios-application-development-7a9703902af6)

## How did I implement VIPER?

Basically I have a protocol file for each scene in the app. This file defines the interaction between each layer as following:

* View - Presenter: protocols to notify changes and to inject information to the UI.
* Presenter - Interactor: protocols to request / receive information to / from the interactor.
* Presenter - Router: protocol to define the transitions between scenes.

Whith this protocols file is really easy to know how each layer notify / request / information to the other ones so we don't have any other way to communicate all the layers.

Another important point is because I'm using protocols it's really easy to define mocks views / presenters / interactors / routers for testing.

```swift
// View / Presenter
protocol SearchListViewInjection : class {
    func showProgress(_ show: Bool, status: String)
    func showProgress(_ show: Bool)
    func showMessageWith(title: String, message: String, actionTitle: String)
    func loadTracks(_ viewModels: [TrackViewModel], fromBeginning: Bool)
    func loadSuggestions(_ suggestions: [SuggestionViewModel])
}

protocol SearchListPresenterDelegate : class {
    func viewDidLoad()
    func searchTrack(_ search: String?)
    func trackSelectedAt(section: Int, index: Int)
    func getSuggestions()
    func suggestionSelectedAt(_ index: Int)
    func sortTracksBy(_ type: SortType)
}

// Presenter / Interactor

typealias TracksGetTracksCompletionBlock = (_ viewModel: [TrackViewModel]?, _ success: Bool, _ error: ResultError?) -> Void
typealias TrackListGetSuggestionsCompletionBlock = ([SuggestionViewModel]) -> Void

protocol SearchListInteractorDelegate : class {
    func getTracksList(search: String?, completion: @escaping TracksGetTracksCompletionBlock)
    func clear()
    func getTrackSelectedAt(_ index: Int) -> TrackViewModel?
    func getAllSuggestions(completion: @escaping TrackListGetSuggestionsCompletionBlock)
    func getSuggestionAt(index: Int) -> SuggestionViewModel?
    func getInitialSearch() -> String
    func sortTracksBy(_ sortType: SortType)
    func getLocalTracks() -> [TrackViewModel]
}

// Presenter / Router
protocol SearchListRouterDelegate : class {
    func showTrackDetail(_ track: TrackViewModel, allTracks: [TrackViewModel])
}
```

## First at all. Where is the data came from?

I'm using the iTunes search api. You can check the API [here](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/).

## Data models

### Network data models

```swift
public struct TracksResponse: Decodable {
    
    let resultCount: UInt
    let results: [TrackResponse]
    
}

public struct TrackResponse: Decodable {
    
    let artistName: String
    let trackId: Int
    let trackName: String
    let trackViewUrl: String
    let previewUrl: String?
    let artworkUrl100: String
    let releaseDate: String
    let primaryGenreName: String
    let trackPrice: Float?
    let currency: String
    let trackTimeMillis: Int?
    let collectionName: String?
    
}
```

I'm using a Swift Standard Library decodable functionality in order to manage a type that can decode itself from an external representation (I really ❤ this from Swift).

Reference: [Apple documentation](https://developer.apple.com/documentation/swift/swift_standard_library/encoding_decoding_and_serialization)

### Local suggestions data model

This model is used for the local suggestions:

```swift
class SearchSuggestion: Object {
    
    @objc dynamic var suggestionId: String?
    @objc dynamic var suggestion: String = ""
    @objc dynamic var timestamp: TimeInterval = NSDate().timeIntervalSince1970
    
    override class func primaryKey() -> String? {
        return "suggestionId"
    }
    
}
```

As I'm using Realm for this it's important to define a class to manage each model in the database. In this case we only have one model (FavoriteRecipe)

Reference: [Realm](https://realm.io/docs/swift/latest)

## Managers

I think using managers is a good idea but be careful!. Please don't create managers as if the world were going to end tomorrow.

I'm using 5 here:

### ReachabilityManager

Used to manage the reachability. In this case I would like to notify a little issue related with the simulator. ***It seems Xcode has an issue with the simulator because if you try to turn off the wifi and turning on again, the observer for the state change is not triggering. It's working 100% fine in a real device***.

### SearchSuggestionsManager

Used to save the sucessfull searchs locally using a Realm database.

### TrackManager

Used to process the tracks from iTunes API.

### PlayerManager

Used to process the songs from iTunes API.

### ShareManager

Used to share the current track using UIActivityViewController.

## How it looks like?