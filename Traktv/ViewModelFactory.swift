import Foundation
import RxCocoa
import RxSwift
import Action
import Boomerang


struct ViewModelFactory {
    
    static func popularMovies() -> ListViewModelType {
        return WatchablesViewModel(type:.movie)
    }
    static func popularShows() -> ListViewModelType {
        return WatchablesViewModel(type:.show)
    }
    
    static func watchableItem(with model:Watchable) -> ItemViewModelType {
        
        return WatchableItemViewModel(model: model)
    }
    
    
    static func watchableDetail(with model:WatchableWithDetail) -> ViewModelType {
        return WatchableDetailViewModel(with: model)
    }
}
