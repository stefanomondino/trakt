import Foundation
import Boomerang
import UIKit
import MediaPlayer
import AVKit






struct Router : RouterType {
    public static func root() -> UIViewController {
        let movies :GenericViewController = Storyboard.main.scene(.generic)
        let shows : GenericViewController = Storyboard.main.scene(.generic)

        let home : GenericViewController = Storyboard.main.scene(.generic)
        let vcs =  [home.withViewModel(ViewModelFactory.watchableHome()).withNavigation(),
                    movies.withViewModel(ViewModelFactory.popularMovies()).withNavigation(),
                    shows.withViewModel(ViewModelFactory.popularShows()).withNavigation()]
        let tab = UITabBarController()
        tab.setViewControllers(vcs, animated: false)
        return tab
                    
    }
        
    public static func start(_ delegate:AppDelegate) {
        
        delegate.window = UIWindow(frame: UIScreen.main.bounds)
        delegate.window?.rootViewController = self.root()
        
        delegate.window?.makeKeyAndVisible()
        
        
//        self.open(DataManager.loginURL, from: self.rootController()!).execute()
        
        
    }

    public static func rootController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    public static func restart() {
        UIApplication.shared.keyWindow?.rootViewController = Router.root()
    }
   

    
    public static func from<Source> (_ source:Source, viewModel:ViewModelType) -> RouterAction where Source: UIViewController {
        switch viewModel {
        case let viewModel as LoginViewModel :
            return self.login(with: viewModel, from: source)
            
            
        case let viewModel as WatchableDetailViewModel :
            let destination : GenericViewController = Storyboard.main.scene(.watchableDetail)
            return UIViewControllerRouterAction.push(source: source, destination: destination.withViewModel(viewModel))
        case let viewModel as GenericViewModelType :
            let destination : GenericViewController = Storyboard.main.scene(.generic)
            return UIViewControllerRouterAction.push(source: source, destination: destination.withViewModel(viewModel))
        default:
            return EmptyRouterAction()
        }
    }

    
    
    
}
