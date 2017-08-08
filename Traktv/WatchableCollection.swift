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
        case .popularMovies : return DataRepository.movies(with: .popular)
        case .popularShows : return DataRepository.shows(with:.popular)
        case .trendingMovies : return DataRepository.movies(with: .trending)
        case .trendingShows : return DataRepository.shows(with:.trending)
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

class WatchableCollection: PosterableCollection {
    var type:WatchableCollectionType
    override var title:String {
            get { return type.title }
            set { }
    }
    init(with type:WatchableCollectionType) {
        self.type = type
        super.init(with: type.data.map { $0 })
        
        
    }
}

