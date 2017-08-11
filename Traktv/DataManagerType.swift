//
//  DataManagerType.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift

protocol DataManagerType {
    static func movies(with group:TraktvGroupType) -> Observable<[Watchable]>
    static func shows(with group:TraktvGroupType) -> Observable<[Watchable]>
    static func detail(of watchable:Watchable) -> Observable<WatchableDetail>
    static func detail(of season:Season) -> Observable<Season>
    static func detail(of episode:Episode) -> Observable <Episode>
    static func login() -> Observable<()>
}
