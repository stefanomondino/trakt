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
    var detail: WatchableDetail?

    
    var title:String = ""
    var id:Int = 0
    var tmdbId : Int = 0
    
    var poster: URL? {
        return self.detail?.poster
    }
    
    var fanartId : Int = 0
    var year: Int = 0
    
    required init?(json: JSON) {
        var json = json
        if let inner:JSON = "show" <~~ json {
            json = inner
        }
        self.fanartId = "ids.tvdb" <~~ json ?? 0
        self.title = "title" <~~ json ?? ""
        self.id = "ids.trakt" <~~ json ?? 0
        self.tmdbId = "ids.tmdb" <~~ json ?? 0
        self.year = "year" <~~ json ?? 0
    }
    
    
    
    
    
}

class TMDBShow: ShowDetail {
    var title:String = ""
    var id:Int = 0
    var tmdbId : Int = 0
    var year: Int = 0
    var poster: URL?
    var backdrop: URL?
    var fanart: FanartDetail?
    var fanartId: Int = 0
    
    var firstAirDate : Date?
    var homepage: URL?
    var isInProduction : Bool = false
    var overview: String = ""
    var seasons: [Season]
    static var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    required init?(json: JSON) {
        
        self.title = "title" <~~ json ?? ""
        self.id = "id" <~~ json ?? 0
        
        if let posterPath:String = "poster_path" <~~ json {
            poster = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        if let backdropPath:String = "backdrop_path" <~~ json {
            backdrop = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
        }
        
        self.overview = "overview" <~~ json ?? ""
        self.isInProduction = "in_production" <~~ json ?? false
        self.homepage = "homepage" <~~ json
        self.firstAirDate = Decoder.decode(dateForKey: "last_air_date", dateFormatter: TMDBShow.dateFormatter)(json)
        
        self.seasons = "seasons" <~~ json ?? []
    }
}

class Season : Decodable, Posterable {
    static var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    var airDate : Date?
    var id: Int = 0
    var episodeCount : Int = 0
    var poster: URL?
    var number: Int?
    required init?(json: JSON) {
        self.id = "id" <~~ json ?? 0
        self.airDate = Decoder.decode(dateForKey: "last_air_date", dateFormatter: TMDBShow.dateFormatter)(json)
        self.episodeCount = "episode_count" <~~ json ?? 0
        if let posterPath:String = "poster_path" <~~ json {
            poster = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        self.number = "season_number" <~~ json
        
    }
}


class FanartShowDetail : FanartDetail {
    var backgrounds:[FanartItem]?
    required init?(json: JSON) {
        backgrounds = "showbackground" <~~ json
    }
}
