//
//  Episode.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Gloss

class Episode : Decodable, Posterable {
    static var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    var airDate : Date?
    var id: Int = 0
    var poster: URL?
    var number: Int
    var title: String
    var voteAverage : Float  = 0
    var crew : [Person]?
    var guestStars: [Person]?
    required init?(json: JSON) {
        self.id = "id" <~~ json ?? 0
        self.title = "name" <~~ json ?? ""
        self.airDate = Decoder.decode(dateForKey: "air_date", dateFormatter: TMDBShow.dateFormatter)(json)
        self.number = "episode_number" <~~ json ?? 0
        if let posterPath:String = "still_path" <~~ json {
            poster = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        self.crew = "crew" <~~ json
        self.guestStars = "guest_stars" <~~ json
        self.voteAverage = "vote_average" <~~ json ?? 0
    }
}
