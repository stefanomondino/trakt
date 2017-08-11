//
//  TMDB.swift
//  Traktv
//
//  Created by Stefano Mondino on 05/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Boomerang
import Moya

enum TMDB {
    case movie(Int)
    case show(Int)
    case season(showId:Int, seasonNumber:Int)
}

extension TMDB : Moya.TargetType {
    
   
    
    var baseURL: URL {
        return URL(string:"https://api.tmdb.org/3")!
    }
    var path: String {
        switch self {
        case .show(let id) :
            return "tv/\(id)"
        case .movie(let id) :
            return "movie/\(id)"
        case .season(let showId, let seasonNumber) :
            return "tv/\(showId)/season/\(seasonNumber)"
        }
    }
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String : Any]? {
        var defaultParameters = ["api_key":apiKey]
        switch self {
        case .season:
            defaultParameters["append_to_response"] = "credits"
        default: break
        }
        return defaultParameters
    }
    var parameterEncoding: Moya.ParameterEncoding {
        return URLEncoding.default
    }
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Moya.Task {
        return .request
    }
    
    
}
