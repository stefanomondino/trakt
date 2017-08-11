//
//  WatchableGalleryItemViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 09/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

final class PosterableGalleryItemViewModel : ItemViewModelType, ListViewModelType, ViewModelTypeSelectable {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = View.posterableGallery
    var dataHolder: ListDataHolderType = ListDataHolder()
    var title:String
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Posterable else {
            return nil
        }
        return ViewModelFactory.posterableItem(with: item)
    }
    
    var flowType:FlowType = FlowType.horizontal.modifying(itemsPerLine:{_ in return 1 })
    
    var selection: Action<Input, Output> = Action {_ in .empty() }
    init(model: PosterableCollection, selection outerSelection:Action<Input,Output>) {
        self.model = model
        self.title = model.title
        self.dataHolder = ListDataHolder(data: model.data.structured())
        self.selection =    Action {[unowned self] input in
            switch input {
            case .item(let indexPath):
                if let model = self.model(atIndex: indexPath) as? Posterable {
                    outerSelection.execute(.model(model))
                }
                return .empty()
            default: return .empty()
            }
        }
    }

    
}


