//
//  WatchableCollection.swift
//  Traktv
//
//  Created by Stefano Mondino on 09/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift

enum WatchableCollectionType {
    case popularShows
    case popularMovies
    case trendingShows
    case trendingMovies
    
    var data:Observable<[Watchable]> {
        switch self {
        case .popularMovies : return DataManager.movies(with: .popular)
        case .popularShows : return DataManager.shows(with:.popular)
        case .trendingMovies : return DataManager.movies(with: .trending)
        case .trendingShows : return DataManager.shows(with:.trending)
        }
    }
    
    var title: String {
        switch self {
        case .popularShows:
            return "Popular Shows".localized()
        case.popularMovies:
            return "Popular Movies".localized()
        default: return "Trending".localized()
        }
    }
    
}

class WatchableCollection: ModelType {
    var data:Observable<[Watchable]>
    var type:WatchableCollectionType
    var title:String { return type.title }
    init(with type:WatchableCollectionType) {
        self.type = type
        self.data = type.data
    }
}
