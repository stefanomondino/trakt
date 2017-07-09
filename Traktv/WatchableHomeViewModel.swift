//
//  WatchableHomeViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 09/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action



final class WatchableHomeViewModel : ListViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        
        switch model {
        case let watchable as Watchable : return ViewModelFactory.watchableItem(with:watchable)
        case let watchable as WatchableCollection : return ViewModelFactory.watchableGalleryItem(with:watchable, selection: self.selection)
        default: return model as? ItemViewModelType
        }
        

    }
    
    lazy var selection:Action<Input,Output> = Action { input in
        switch input {
        case .model(let model):
            guard let model = (model as? WatchableWithDetail) else {
                return .empty()
            }
            
            let destinationViewModel = ViewModelFactory.watchableDetail(with: model)
            return .just(.viewModel(destinationViewModel))
        case .item(let indexPath):
            guard let model = (self.model(atIndex:indexPath) as? WatchableWithDetail) else {
                return .empty()
            }
            
            let destinationViewModel = ViewModelFactory.watchableDetail(with: model)
            return .just(.viewModel(destinationViewModel))
        default : return .empty()
        }
    }
    
    
    init() {
        self.dataHolder = ListDataHolder(withModels: [WatchableCollection(with: .popularMovies),
                                                      WatchableCollection(with: .popularShows),
                                                       WatchableCollection(with: .trendingMovies),
                                                        WatchableCollection(with: .trendingShows)
            ])
    }
}
