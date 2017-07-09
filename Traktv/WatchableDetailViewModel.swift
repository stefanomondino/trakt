//
//  WatchableDetailViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action


final class WatchableDetailViewModel : ListViewModelType, ViewModelTypeSelectable, ListViewModelTypeSectionable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? WatchableDetail else {
            return model as? ItemViewModelType
        }
//        return ViewModelFactory.__proper_factory_method_here()
        return nil
    }
    var sectionIdentifiers: [ListIdentifier] {
        return [View.posterGallery]
    }
    lazy var selection : Action<Input,Output> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex:indexPath) as? WatchableDetail) else {
                return .empty()
            }
//            let destinationViewModel = __proper_factory_method_here__
//            return .just(.viewModel(destinationViewModel))
            return .empty()
        default: return .empty()
        }

    }
    
    
    init(with watchable:WatchableWithDetail) {
        
        let data = Observable.just(watchable).map { watchable -> ModelStructure in
            
            return ModelStructure([WatchableTitleItemViewModel(model:watchable)],sectionModel:PosterGalleryItemViewModel(model: watchable))
        
        }
        
        self.dataHolder = ListDataHolder(data:data )
        
    }
}
