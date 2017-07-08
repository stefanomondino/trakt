import Foundation
import Boomerang
import UIKit
import SafariServices
import MediaPlayer
import AVKit
import Action

@available(iOS 9.0, *)
extension SFSafariViewController {
    class func canOpenURL(URL: URL) -> Bool {
        return URL.host != nil && (URL.scheme == "http" || URL.scheme == "https")
    }
}


extension Router {
    public static func open<Source> (_ url:URL?, from source:Source) -> RouterAction
        where Source: UIViewController{
            if (url == nil) {return EmptyRouterAction()}
            if (!SFSafariViewController.canOpenURL(URL:url!)) {
                return UIViewControllerRouterAction.custom(action: {
                    UIApplication.shared.openURL(url!)
                })
            }
            let vc = SFSafariViewController(url: url!, entersReaderIfAvailable: true)
            return UIViewControllerRouterAction.modal(source: source, destination: vc, completion: nil)
    }
    public static func login<Source> (with viewModel:LoginViewModel, from source:Source) -> RouterAction
        where Source: UIViewController{
            
            if (!SFSafariViewController.canOpenURL(URL:viewModel.url)) {
                return UIViewControllerRouterAction.custom(action: {
                    UIApplication.shared.openURL(viewModel.url)
                })
            }
            let vc = SFSafariViewController(url: viewModel.url, entersReaderIfAvailable: true)
            vc.bind(to: viewModel, afterLoad: true)
            return UIViewControllerRouterAction.modal(source: source, destination: vc, completion: nil)
    }
}

extension SFSafariViewController : ViewModelBindable {
    public var viewModel: ViewModelType? {
        get { return nil }
        set {}
    }
    public func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? LoginViewModel else {
            return
        }
        viewModel.selection.elements.subscribe(onNext: {[weak self] _ in self?.dismiss(animated: true, completion: nil) }).disposed(by: self.disposeBag)
        viewModel.selection.execute(.login)
    }
}

final class LoginViewModel : ViewModelTypeSelectable {
    var url = DataManager.loginURL ?? URL(string: "https://www.google.com")!
    var selection: Action<Input, Output> = Action { _ in
        return DataManager.login().map { _ in .dismiss }
    }
}
