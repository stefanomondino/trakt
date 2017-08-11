//
//  Season.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Gloss

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
    var episodes : [Episode]?
    var cast : [Person]?
    weak var show:TMDBShow?
    var title: String {
        guard let number = number else { return "" }
        return "\("Season".localized()) \(number)"
    }
    required init?(json: JSON) {
        self.id = "id" <~~ json ?? 0
        self.episodes = "episodes" <~~ json
        self.airDate = Decoder.decode(dateForKey: "air_date", dateFormatter: TMDBShow.dateFormatter)(json)
        self.episodeCount = "episode_count" <~~ json ?? 0
        if let posterPath:String = "poster_path" <~~ json {
            poster = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        self.number = "season_number" <~~ json
        self.cast = "credits.cast" <~~ json
        
    }
}

