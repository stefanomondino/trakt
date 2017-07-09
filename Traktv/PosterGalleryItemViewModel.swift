//
//  PosterGalleryViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 09/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

enum PosterGallerySelectionInput : SelectionInput {
    case item(IndexPath)
}
enum PosterGallerySelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}

final class PosterGalleryItemViewModel : ItemViewModelType, ListViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    var model: ItemViewModelType.Model
    var itemIdentifier: ListIdentifier = View.posterGallery
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Image else {
            return nil
        }
        return ViewModelFactory.posterItem(with:item)
    }
    
    lazy var selection : Action<PosterGallerySelectionInput,PosterGallerySelectionOutput> = Action { input in
        switch input {
        
//        case .item(let indexPath):
//            guard let model = (self.model(atIndex:indexPath) as? PosterGallery) else {
//                return .empty()
//            }
        default:    return .empty()
//            let destinationViewModel = __proper_factory_method_here__
//            return .just(.viewModel(destinationViewModel))
        }
    }
    
    
    init(model:WatchableWithDetail) {
        self.model = model
//        self.dataHolder = ListDataHolder(data:)
        let data = DataManager.detail(of: model).map { detail -> ModelStructure in
            return ModelStructure(detail.fanart?.backgrounds?.flatMap { $0.url} ?? [])
        }
        self.dataHolder = ListDataHolder(data:data)
        
        
//        self.dataHolder
    }
}
