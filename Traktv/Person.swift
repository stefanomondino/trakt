//
//  Person.swift
//  Traktv
//
//  Created by Stefano Mondino on 11/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Gloss

class Person : Decodable, Posterable {
    static var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    var id: Int = 0
    var poster: URL?
    var title: String
    var job: String?
    required init?(json: JSON) {
        self.id = "id" <~~ json ?? 0
        self.title = "name" <~~ json ?? ""
        self.job = "job" <~~ json
        
        if let posterPath:String = "profile_path" <~~ json {
            poster = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
        
    }
}
