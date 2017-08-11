//
//  SeasonViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action



final class SeasonViewModel : GenericViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        switch model {
        case let item as Posterable:
             return ViewModelFactory.listableItem(with: item)
        default : return model as? ItemViewModelType
            
        }
       
    }
    var title: String
    var flowType: FlowType {
        return .lines
    }
    lazy var selection : Action<Input,Output> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex:indexPath) as? Episode) else {
                return .empty()
            }
            
            let destinationViewModel = ViewModelFactory.episode(with: model)
            return .just(.viewModel(destinationViewModel))
        default : return .empty()
        }
    }
    
    
    init(with season:Season) {
        let data = DataRepository.detail(of: season).map { season -> ModelStructure in
            var array : [ModelStructure] = []
            if let cast = season.cast {
                array += [ModelStructure(cast)]
            }
            if let episodes = season.episodes {
                array += [ModelStructure(episodes)]
            }
            return ModelStructure(children: array)
        }
        self.dataHolder = ListDataHolder(data: data)
        self.title = "\("Season".localized()) \(season.number ?? 0)"
    }
}
