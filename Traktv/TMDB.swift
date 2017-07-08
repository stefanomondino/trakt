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
        }
    }
    var method: Moya.Method {
        return .get
    }
    var parameters: [String : Any]? {
        return ["api_key":apiKey]
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
