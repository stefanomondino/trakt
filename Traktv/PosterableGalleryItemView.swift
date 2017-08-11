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
    var flowDelegate:FlowDelegate?
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? PosterableGalleryItemViewModel else {
            return
        }
        if (self.isPlaceholder) { return }
        disposeBag = DisposeBag()
        self.flowDelegate =  FlowDelegate(with:viewModel.flowType, action:viewModel.selection)
        self.collectionView.delegate = flowDelegate
        self.viewModel = viewModel
        self.lbl_title?.text = viewModel.title
        
        self.collectionView.bind(to: viewModel)
        viewModel.reload()
    }
    
}
