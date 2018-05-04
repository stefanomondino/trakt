import RxSwift
import Moya
import Gloss

struct APIDataManager : DataManagerType {
    
    enum ErrorType : Swift.Error {
        case genericError
    }
    
    private static var accessToken:AccessToken?
    
   
    
    static var loginURL : URL? {
        return  (try? self.provider.endpoint(.oauth).urlRequest())?.url
    }
    static let provider = MoyaProvider<Traktv> (endpointClosure: { (target) -> Endpoint in
        let endpoint = MoyaProvider.defaultEndpointMapping(for:target)
        
        return endpoint.adding(newHTTPHeaderFields: jsonify([
            "trakt-api-key" ~~> Traktv.clientID,
            "trakt-api-version" ~~> "2",
            "Authorization" ~~> (target.shouldAuthorize ? APIDataManager.accessToken?.authorizationHeader : nil)
            ]) as? [String:String] ?? [:])
        
    },  plugins:[NetworkLoggerPlugin(cURL:true)] )
    
    static let tmdb = MoyaProvider<TMDB>(plugins:[NetworkLoggerPlugin(cURL:true)] )
    static let fanart = MoyaProvider<Fanart>(plugins:[NetworkLoggerPlugin(cURL:true)] )
    
    static func movies(with group:TraktvGroupType) -> Observable<[Watchable]> {
        return self.provider.rx.request(.list(type:.movie, group:group)).asObservable().mapArray(type: Movie.self).map {$0}
    }
    static func shows(with group:TraktvGroupType) -> Observable<[Watchable]> {
        return self.provider.rx.request(.list(type:.show, group:group))
            .asObservable()
            .mapArray(type: Show.self).map {$0}
    }
    
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
                    
                    return self.provider.rx.request(.token(.code(code))).asObservable()
                        .mapObject(type: AccessToken.self)
                        .map { accessToken in
                            self.accessToken = accessToken
                            return ()
                    }
                    
                }
                
                return .error(ErrorType.genericError)
                
                
            } ?? .error(ErrorType.genericError)
    }
    
    static func detail(of watchable:Watchable) -> Observable<WatchableDetail> {
        switch watchable {
        case let movie as Movie : return self.detail(of: movie)
        case let show as Show : return self.detail(of: show)
        default : return .empty()
        }
    }
    private static func detail(of movie:Movie) -> Observable<WatchableDetail> {
        return .deferred {
            guard let detail = movie.detail else {
                return self.tmdb.rx.request(.movie(movie.tmdbId)).asObservable()
                    .mapObject(type: TMDBMovie.self)
                    .flatMapLatest { detail in
                        return fanart.rx.request(.movie(movie.fanartId)).asObservable()
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
                return self.tmdb.rx.request(.show(show.tmdbId)).asObservable()
                    .mapObject(type: TMDBShow.self)
                    .flatMapLatest { detail in
                        return fanart.rx.request(.show(show.fanartId)).asObservable()
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
    
    static func detail(of season:Season) -> Observable<Season> {
        return .deferred {
           if (season.episodes == nil) {
                return self.tmdb.rx.request(.season(showId:season.show?.id ?? 0, seasonNumber: season.number ?? 0)).asObservable()
                    .mapObject(type: Season.self)

            }
            return .just(season)
        }
    }
    static func detail(of episode:Episode) -> Observable <Episode> {
        return .just(episode)
    }
}

private class AccessToken : JSONDecodable {
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


