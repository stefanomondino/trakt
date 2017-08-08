//
//  DataRepository.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Dip
import RxSwift

struct DataRepository : DataManagerType {
    
    static let dependencyContainer = DependencyContainer()
    private static var dataManager : DataManagerType.Type {
        return type(of:(try! dependencyContainer.resolve() as DataManagerType))
    }
    
    static func detail(of item: Watchable) -> Observable<WatchableDetail> {
        
        return dataManager.detail(of:item)
    }
    static func shows(with group: TraktvGroupType) -> Observable<[Watchable]> {
        return dataManager.shows(with:group)
    }
    static func movies(with group: TraktvGroupType) -> Observable<[Watchable]> {
        return dataManager.movies(with:group)
    }
    static func login() -> Observable<()> {
        return dataManager.login()
    }
}
