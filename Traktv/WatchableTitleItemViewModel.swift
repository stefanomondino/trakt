//
//  WatchableTitleItemViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class WatchableTitleItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = View.watchableTitle
    
    var title:String
    var poster:ObservableImage?
    init(model: Watchable) {
        self.model = model
        self.title = model.title
        self.poster = DataManager.detail(of: model).flatMapLatest { detail -> ObservableImage in
            switch model {
            case let show as Show :
                
                return  detail.backdrop?.getImage() ?? .just(nil)
            default : return detail.poster?.getImage() ?? .just(nil)
            }
            
        }.startWith(nil)
        
        
    }
}
