//
//  Fanart.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Moya

enum Fanart {
    case show(Int)
    case movie(Int)
    
}

extension Fanart : Moya.TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    

    
    var baseURL: URL {
        return URL(string:"http://webservice.fanart.tv/v3")!
    }
    var path: String {
        switch self {
        case .show(let id) :
            return "tv/\(id)"
        case .movie(let id) :
            return "movies/\(id)"
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
        return .requestParameters(parameters: self.parameters ?? [:], encoding: URLEncoding.methodDependent)
    }
    
    
}
