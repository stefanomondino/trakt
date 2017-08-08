//
//  MovieItemViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 05/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class WatchableItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = View.watchable
    var title:String
    var poster:ObservableImage?
    init(model: Watchable) {
        self.model = model
        self.title = model.title
        self.poster = DataRepository.detail(of: model).flatMapLatest { detail -> ObservableImage in
            switch model {
            case let show as Show :
                
                return  detail.backdrop?.getImage() ?? .just(nil)
            default : return detail.poster?.getImage() ?? .just(nil)
            }
           
        }.startWith(nil)
        
        
    }
}
