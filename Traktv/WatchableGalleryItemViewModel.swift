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

final class WatchableGalleryItemViewModel : ItemViewModelType, ListViewModelType, ViewModelTypeSelectable {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = View.watchableGallery
    var dataHolder: ListDataHolderType = ListDataHolder()
    var title:String
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Watchable else {
            return nil
        }
        return ViewModelFactory.watchableItem(with: item)
    }
    var selection: Action<Input, Output> = Action {_ in .empty() }
    init(model: WatchableCollection, selection outerSelection:Action<Input,Output>) {
        self.model = model
        self.title = model.title
        self.dataHolder = ListDataHolder(data: model.data.structured())
        self.selection =    Action {[unowned self] input in
            switch input {
            case .item(let indexPath):
                if let model = self.model(atIndex: indexPath) as? Watchable {
                    outerSelection.execute(.model(model))
                }
                return .empty()
            default: return .empty()
            }
        }
    }
    
    
}