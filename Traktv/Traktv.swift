//
//  Traktv.swift
//  Traktv
//
//  Created by Stefano Mondino on 05/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Boomerang
import Moya
import Gloss
enum TraktvTokenType {
    case code(String)
    case refresh(String)
}

enum TraktvViewType {
    case show
    case movie
    var plural:String {
        switch self {
        case .show : return "shows"
        case .movie : return "movies"
        }
    }
    var singular:String {
        switch self {
        case .show : return "show"
        case .movie : return "movie"
        }
    }
    var modelClass: ModelType.Type {
        switch self {
        case .show : return Movie.self
        case .movie : return Movie.self
        }
    }
}

enum TraktvGroupType {
    case popular
    case trending
    var name:String {
        switch self {
        case .popular : return "popular"
        case .trending : return "trending"
        }
    }
}


enum Traktv {
    case oauth
    case list(type:TraktvViewType, group:TraktvGroupType)
    
    case token(TraktvTokenType)

    static var redirectURI:String { return "testapp://auth" }
    static var scheme:String { return URLComponents(string:redirectURI)?.scheme ?? "" }
}

extension Traktv : Moya.TargetType {
    var baseURL: URL {
        return URL(string:"https://api.trakt.tv")!
    }
    var path: String {
        switch self {
        case .oauth:
            return "oauth/authorize"
        case .token:
            return "oauth/token"
        case .list(let type, let group) :
            return "\(type.plural)/\(group.name)"
        
            
        }
    }
    var method: Moya.Method {
        switch self {
        case .token :
             return .post
            default:
            return .get
        }
    }
    var parameters: [String : Any]? {
        switch self {
        case .token(let token) :
            let params = [
                "client_id" : Traktv.clientID,
                "client_secret" : Traktv.clientSecret,
                "redirect_uri" : Traktv.redirectURI
            ]
            switch token {
            case .code(let code) :
                return params + ["grant_type":"authorization_code", "code": code]
            case .refresh(let refreshToken) :
                return params + ["grant_type":"refresh_token", "refresh_token": refreshToken]
            }
        case .oauth :
            return ["response_type":"code","client_id":Traktv.clientID,"redirect_uri":Traktv.redirectURI]
        default : return ["limit":"50"]
        }
        
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

extension Traktv : AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
            default : return false
        }
    }
}
