//
//  WatchableGalleryItemView.swift
//  Traktv
//
//  Created by Stefano Mondino on 09/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import UIKit
import Boomerang
import RxSwift
import Action
import RxCocoa

class WatchableGalleryItemView: UIView, ViewModelBindable, EmbeddableView, UICollectionViewDelegateFlowLayout {
    
    var viewModel:ItemViewModelType?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl_title: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? PosterableGalleryItemViewModel else {
            return
        }
        if (self.isPlaceholder) { return }
        disposeBag = DisposeBag()
        
        self.viewModel = viewModel
        self.lbl_title?.text = viewModel.title
        self.collectionView.delegate = self
        self.collectionView.bind(to: viewModel)
        viewModel.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.size.height
        return CGSize(width: h * 50/75, height: h)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (self.viewModel as? PosterableGalleryItemViewModel)?.selection.execute(.item(indexPath))
    }
}
