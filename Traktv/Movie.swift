//
//  Movie.swift
//  Traktv
//
//  Created by Stefano Mondino on 05/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Boomerang
import Gloss


class Movie : WatchableWithDetail {
    var poster: URL? {
        return self.detail?.poster
    }
    var title:String = ""
    var id:Int = 0
    var tmdbId : Int = 0
    var year: Int = 0
    var detail:WatchableDetail?
    var watchers:Int?
    var fanartId: Int
    required init?(json: JSON) {
        var json = json
        
        //Some apis (like "trending") returns a nested movie object.
        
        if let inner:JSON = "movie" <~~ json {
            watchers = "watching" <~~ json
            json = inner
        }
        self.title = "title" <~~ json ?? ""
        self.id = "ids.trakt" <~~ json ?? 0
        self.tmdbId = "ids.tmdb" <~~ json ?? 0
        self.year = "year" <~~ json ?? 0
        self.fanartId = tmdbId
    }
    
   
    
    
    
}

class TMDBMovie: WatchableDetail {
    var title:String = ""
    var id:Int = 0
    var tmdbId : Int = 0
    var fanartId: Int = 0
    var year: Int = 0
    var poster: URL?
    var backdrop : URL?
    var fanart: FanartDetail?
    var overview: String = ""
    required init?(json: JSON) {
        
        
        self.title = "title" <~~ json ?? ""
        self.id = "id" <~~ json ?? 0
        if let posterPath:String = "poster_path" <~~ json {
            poster = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        if let backdropPath:String = "backdrop_path" <~~ json {
            backdrop = URL(string: "https://image.tmdb.org/t/p/w1000\(backdropPath)")
        }
        self.overview = "overview" <~~ json ?? ""
    }
}

class FanartMovieDetail : FanartDetail {
    var backgrounds:[FanartItem]?
    required init?(json: JSON) {
        backgrounds = "moviebackground" <~~ json
    }
}
