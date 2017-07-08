//
//  MoviesViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 05/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

enum MovieSelectionInput : SelectionInput {
    case item(IndexPath)
}
enum MovieSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}


enum WatchableType {
    case show
    case movie
    
    var title:String {
    switch self {
        case .show : return "Popular shows"
        case .movie : return "Popular movies"
    }
    }
    
    var query: Observable<[Watchable]> {
        switch self {
        case .movie :
            return DataManager.popularMovies()
        case .show :
            return DataManager.popularShows()
        }
    }
}

final class WatchablesViewModel : ListViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    var type:WatchableType
    var title: String {
        return type.title
    }
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Watchable else {
            return nil
        }
        return ViewModelFactory.watchableItem(with: item)
    }
    
    lazy var selection:Action<Input,Output> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex:indexPath) as? WatchableWithDetail) else {
                return .empty()
            }
            
            let destinationViewModel = ViewModelFactory.watchableDetail(with: model)
            return .just(.viewModel(destinationViewModel))
        default : return .empty()
        }
    }
    
    
    init(type:WatchableType) {
        self.type = type
        self.dataHolder = ListDataHolder(data: type.query.structured())
    }
}
