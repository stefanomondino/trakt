//
//  MovieViewController.swift
//
//
//  Created by Stefano Mondino on 05/07/17.
//
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang


enum WatchableViewMode {
    case grid
    case backdrops
    
    static func from(_ type:WatchableType) -> WatchableViewMode {
        switch type {
        case .show : return .backdrops
        case .movie : return .grid
        }
    }
    
    var spacing:CGFloat {
        switch self {
        case .grid : return 1
        default : return 0
        }
    }
    var itemAspectRatio : CGFloat {
        switch self {
        case .grid : return 75/50
        case .backdrops: return 25/100
        }
    }
    var itemsPerLine : Int {
        switch self {
        case .grid : return 3
        case .backdrops : return 1
        }
    }
}

class WatchablesViewController : UIViewController, ViewModelBindable, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: WatchablesViewModel?
    var flow:UICollectionViewFlowLayout? {
        return self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    var mode = WatchableViewMode.grid
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? WatchablesViewModel else {
            return
        }
        self.title = viewModel.title
        self.viewModel = viewModel
        self.mode = WatchableViewMode.from(viewModel.type)
        self.collectionView.bind(to:viewModel)
        self.collectionView.delegate = self
        viewModel.selection.elements.subscribe(onNext:{ selection in
            switch selection {
            case .viewModel(let viewModel):
                Router.from(self,viewModel: viewModel).execute()
            default : break
            }
            
        }).addDisposableTo(self.disposeBag)
        viewModel.reload()
        
        let refresh = UIRefreshControl()
        refresh.rx.bind(to: viewModel.dataHolder.reloadAction, controlEvent: refresh.rx.controlEvent(.allEvents), inputTransform: {_ in return nil})
        collectionView.addSubview(refresh)
        viewModel.dataHolder.modelStructure.asObservable().subscribe(onNext: {_ in refresh.endRefreshing()}).disposed(by: disposeBag)
        
        
        //        Router.from(self, viewModel: LoginViewModel()).execute()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return mode.spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return mode.spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: mode.spacing, left: mode.spacing, bottom: mode.spacing, right: mode.spacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.autoWidthForItemAt(indexPath:indexPath, itemsPerLine:mode.itemsPerLine)
        return CGSize(width:w, height: w * mode.itemAspectRatio)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selection.execute(.item(indexPath))
    }
}
