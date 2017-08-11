//
//  EpisodeViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 11/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Boomerang
import Action
import RxSwift

final class EpisodeViewModel : GenericViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Person else {
            return nil
        }
        return ViewModelFactory.listableItem(with: item)
    }
    var title: String
    var flowType: FlowType {
        return FlowType.lines.modifying(itemsPerLine: { return $0.section > 0 ? 1 : 2})
    }
    lazy var selection : Action<Input,Output> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex:indexPath) as? Season) else {
                return .empty()
            }
            return .empty()
            //            let destinationViewModel = __proper_factory_method_here__
        //            return .just(.viewModel(destinationViewModel))
        default : return .empty()
        }
    }
    
    
    init(with episode:Episode) {
        let data = DataRepository.detail(of: episode).map { episode -> ModelStructure in
            
            var array:[ModelStructure] = []
            if let crew = episode.crew {
                array += [ModelStructure(crew)]
            }
            if let stars = episode.guestStars {
                array += [ModelStructure(stars)]
            }
            
            return ModelStructure(children: array)
        }
        self.dataHolder = ListDataHolder(data: data)
        self.title = episode.title
        //self.title = "\("Season".localized()) \(season.number ?? 0)"
    }
}
