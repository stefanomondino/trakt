import UIKit
import Boomerang

enum Storyboard : String {
    case main = "Main"
    func scene<Type:UIViewController>(_ identifier:SceneIdentifier) -> Type {
        return UIStoryboard(name: self.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier.rawValue).setup() as! Type
    }
}
enum SceneIdentifier : String, ListIdentifier {
    case watchables = "watchables"
    case watchableDetail = "watchableDetail"
    var name: String {
        return self.rawValue
    }
    var type: String? {return nil}
}
extension ListViewModelType {
    var listIdentifiers:[ListIdentifier] {
        return /*CollectionViewCell.all() +*/ View.all()
    }
}
enum View : String, ListIdentifier {
    case watchable = "WatchableItemView"
    case watchableTitle = "WatchableTitleItemView"
    case poster = "PosterItemView"
    static func all() -> [View] {
        return [
            .watchable,
            .watchableTitle,
            .poster
        ]
    }

    var isEmbeddable: Bool { return true }
    var name: String {return self.rawValue}
    var type: String? {
        switch self {
        case .poster : return SupplementaryViewType.poster.name
        default: return nil
            
        }
    }
}

enum SupplementaryViewType : String, ListIdentifier {
    case poster = "poster"
    var name: String { return self.rawValue }
    var type: String? { return nil }
    var isEmbeddable: Bool { return false}
}

enum CollectionViewCell : String, ListIdentifier {
    
    case test = "TestItemCollectionViewCell"
    static func all() -> [CollectionViewCell] {
        return [
            .test
        ]
    }
    static func headers() -> [CollectionViewCell] {
        return self.all().filter{ $0.type == UICollectionElementKindSectionHeader}
    }
    var name: String {return self.rawValue}
    var type: String? {
        switch self {
        default: return nil
            
        }
    }
}


