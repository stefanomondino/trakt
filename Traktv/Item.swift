//
//  Item.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Boomerang
import Gloss

protocol Watchable : Decodable, ModelType {
    var title:String { get }
    var id:Int { get }
    var tmdbId : Int { get }
    var fanartId : Int { get }
}
protocol WatchableWithDetail : Watchable {
    var detail:WatchableDetail? { get set }
}
protocol WatchableDetail : Watchable {
    var poster: URL? { get set }
    var backdrop : URL? { get set }
    var fanart : FanartDetail? { get set }
}

class FanartItem : Decodable {
    var url:URL?
    var likes:String
    required init?(json: JSON) {
        url = "url" <~~ json
        likes = "likes" <~~ json ?? "0"
    }
}

protocol FanartDetail : Decodable {
    var backgrounds:[FanartItem]? { get }
}

