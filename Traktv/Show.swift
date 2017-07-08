//
//  Show.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation

import Boomerang
import Gloss


class Show : WatchableWithDetail {
    
    var title:String = ""
    var id:Int = 0
    var tmdbId : Int = 0
    var year: Int = 0
    var detail:WatchableDetail?
    required init?(json: JSON) {
        self.title = "title" <~~ json ?? ""
        self.id = "ids.trakt" <~~ json ?? 0
        self.tmdbId = "ids.tmdb" <~~ json ?? 0
        self.year = "year" <~~ json ?? 0
    }
    
    
    
    
    
}

class TMDBShow: WatchableDetail {
    var title:String = ""
    var id:Int = 0
    var tmdbId : Int = 0
    var year: Int = 0
    var poster: URL?
    var backdrop: URL?
    var fanart: FanartDetail?
    
    required init?(json: JSON) {
        self.title = "title" <~~ json ?? ""
        self.id = "id" <~~ json ?? 0
        if let posterPath:String = "poster_path" <~~ json {
            poster = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        if let backdropPath:String = "backdrop_path" <~~ json {
            backdrop = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
        }
    }
}

class FanartShowDetail : FanartDetail {
    var backgrounds:[FanartItem]?
    required init?(json: JSON) {
        backgrounds = "showbackground" <~~ json
    }
}
