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
    static func watchableHome() -> ListViewModelType {
        return WatchableHomeViewModel()
    }
    static func season(with season:Season) -> ViewModelType {
        return SeasonViewModel(with: season)
    }
    static func episode(with episode:Episode) -> ViewModelType {
        return EpisodeViewModel(with: episode)
    }
    static func watchableItem(with model:Watchable) -> ItemViewModelType {
        
        return WatchableItemViewModel(model: model)
    }
    static func listableItem(with model: Posterable) -> ItemViewModelType {
        return ListableItemViewModel(model: model)
    }
    static func posterableItem(with model:Posterable) -> ItemViewModelType {
        switch model {
        case let model as Watchable : return WatchableItemViewModel(model: model)
        default : return PosterItemViewModel(with: model)
        }
        
    }
    static func watchableGalleryItem(with model:WatchableCollection, selection:Action<Input,Output>) -> ItemViewModelType {
        return PosterableGalleryItemViewModel(model:model, selection:selection)
    }
    static func posterableGalleryItem(with model:PosterableCollection, selection:Action<Input,Output>) -> ItemViewModelType {
        return PosterableGalleryItemViewModel(model:model, selection:selection)
    }
    static func watchableDetail(with model:WatchableWithDetail) -> ViewModelType {
        return WatchableDetailViewModel(with: model)
    }
    
    static func posterItem(with model:Image) -> ItemViewModelType {
        return PosterItemViewModel(model: model)
    }
    static func posterGalleryItem(with model:WatchableWithDetail) -> ItemViewModelType {
        return PosterGalleryItemViewModel(model: model)
    }
}
