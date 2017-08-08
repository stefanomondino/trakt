import RxSwift
import Moya
import Gloss

struct APIDataManager : DataManagerType {
    
    enum ErrorType : Swift.Error {
        case genericError
    }
    
    static var loginURL : URL? {
        return self.provider.endpoint(.oauth).urlRequest?.url
    }
    static let provider = RxMoyaProvider<Traktv> (endpointClosure: { (target) -> Endpoint<Traktv> in
        let endpoint = RxMoyaProvider.defaultEndpointMapping(for:target)
        
        return endpoint.adding(newHTTPHeaderFields: jsonify([
            "trakt-api-key" ~~> Traktv.clientID,
            "trakt-api-version" ~~> "2",
            "Authorization" ~~> (target.shouldAuthorize ? APIDataManager.accessToken?.authorizationHeader : nil)
            ]) as? [String:String] ?? [:])
        
    },  plugins:[NetworkLoggerPlugin(cURL:true)] )
    
    static let tmdb = RxMoyaProvider<TMDB>(plugins:[NetworkLoggerPlugin(cURL:true)] )
    static let fanart = RxMoyaProvider<Fanart>(plugins:[NetworkLoggerPlugin(cURL:true)] )
    
    
    
    
    static func movies(with group:TraktvGroupType) -> Observable<[Watchable]> {
        return self.provider.request(.list(type:.movie, group:group)).mapArray(type: Movie.self).map {$0}
    }
    static func shows(with group:TraktvGroupType) -> Observable<[Watchable]> {
        return self.provider.request(.list(type:.show, group:group)).mapArray(type: Show.self).map {$0}
    }
    
    private static var accessToken:AccessToken?
    
    static func login() -> Observable<()> {
        return (UIApplication.shared.delegate as? AppDelegate)?.rx
            .methodInvoked(#selector(AppDelegate.application(_:open:options:)))
            .map {$0[1] as? URL}
            .take(1)
            .flatMapLatest { url -> Observable<()> in
                if let url = url ,
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                    components.scheme == Traktv.scheme,
                    let code = components.queryItems?.filter({ $0.name == "code"}).map ({ $0.value }).first as? String
                    
                {
                    
                    return self.provider.request(.token(.code(code)))
                        .mapObject(type: AccessToken.self)
                        .map { accessToken in
                            self.accessToken = accessToken
                            return ()
                    }
                    
                }
                
                return .error(ErrorType.genericError)
                
                
            } ?? .error(ErrorType.genericError)
        
        
    }
    static func detail(of item:Watchable) -> Observable<WatchableDetail> {
        switch item {
        case let movie as Movie : return self.detail(of: movie)
        case let show as Show : return self.detail(of: show)
        default : return .empty()
        }
    }
    private static func detail(of movie:Movie) -> Observable<WatchableDetail> {
        return .deferred {
            guard let detail = movie.detail else {
                return self.tmdb.request(.movie(movie.tmdbId))
                    .mapObject(type: TMDBMovie.self)
                    .flatMapLatest { detail in
                        return fanart.request(.movie(movie.fanartId))
                            .mapObject(type: FanartMovieDetail.self)
                            .map { $0 as FanartMovieDetail?}
                            .catchErrorJustReturn(nil)
                            //.catchError {_ -> Observable<FanartMovieDetail?> in return .just(nil)}
                            .map {
                                detail.fanart = $0
                                movie.detail = detail
                                return detail
                        }
                    }
                    .map {$0}
                
            }
            return .just(detail)
        }
    }
    private static func detail(of show:Show) -> Observable<WatchableDetail> {
        return .deferred {
            guard let detail = show.detail else {
                return self.tmdb.request(.show(show.tmdbId))
                    .mapObject(type: TMDBShow.self)
                    .flatMapLatest { detail in
                        return fanart.request(.show(show.fanartId))
                            .mapObject(type: FanartShowDetail.self)
                            .map { $0 as FanartShowDetail?}
                            .catchErrorJustReturn(nil)
                            .map {
                                detail.fanart = $0
                                show.detail = detail
                                return detail
                        }
                    }
                    .map {$0}
            }
            return .just(detail)
        }
    }
    
}

private class AccessToken : Decodable {
    var accessToken:String = ""
    var refreshToken:String = ""
    var scope:String?
    var tokenType : String?
    var createdAt: Int?
    var expiresIn : Int?
    var authorizationHeader : String? { return "Bearer \(accessToken)" }
    required init?(json: JSON) {
        self.accessToken = "access_token" <~~ json ?? ""
        self.refreshToken = "refresh_token" <~~ json ?? ""
        self.tokenType = "token_type" <~~ json
        self.scope = "scope" <~~ json
    }
}


