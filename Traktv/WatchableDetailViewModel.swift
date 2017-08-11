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


final class WatchableDetailViewModel : GenericViewModelType, ViewModelTypeSelectable, ListViewModelTypeSectionable {
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
            guard let model = (self.model(atIndex:indexPath) as? ModelType) else {
                return .empty()
            }
            switch model {
            case let model as Season : return .just(.viewModel(SeasonViewModel(with: model)))
            default : break
            }
            //            let destinationViewModel = __proper_factory_method_here__
            //            return .just(.viewModel(destinationViewModel))
            return .empty()
        case .model(let model) :
            switch model {
            case let model as Season : return .just(.viewModel(SeasonViewModel(with: model)))
            default : return .empty()
            }
        default: return .empty()
        }
        
    }
    var title: String { return "" }
    
    convenience init(with watchable:WatchableWithDetail) {
        
        switch watchable {
        case let show as Show : self.init(with: show)
        case let movie as Movie: self.init(with: movie)
        default : self.init()
        }
        
    }
    init() {
        
    }
    private init (with show:Show) {
        let data = Observable.just(show).map { show -> ModelStructure in
            guard let detail = show.detail as? ShowDetail else {
                return ModelStructure([])
            }
            let header = ModelStructure([WatchableTitleItemViewModel(model:show)],sectionModel:PosterGalleryItemViewModel(model: show))
            
            let seasonCollection = PosterableCollection(with:detail.seasons, title: "" )
            let seasons = ModelStructure([ViewModelFactory.posterableGalleryItem(with: seasonCollection , selection: self.selection)])
            return ModelStructure(children: [header,seasons])
            
        }
        
        self.dataHolder = ListDataHolder(data:data )
    }
    
    private init (with movie:Movie) {
        let data = Observable.just(movie).map { movie -> ModelStructure in
            
            return ModelStructure([WatchableTitleItemViewModel(model:movie)],sectionModel:PosterGalleryItemViewModel(model: movie))
            
        }
        
        self.dataHolder = ListDataHolder(data:data)
    }
}
