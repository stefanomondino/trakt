//
//  MovieItemView.swift
//  Traktv
//
//  Created by Stefano Mondino on 05/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import UIKit
import Boomerang
import RxSwift
import Action
import RxCocoa

class WatchableItemView: UIView, ViewModelBindable, EmbeddableView {
    
    var viewModel:ItemViewModelType?
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_poster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? WatchableItemViewModel else {
            return
        }
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        self.lbl_title.text = viewModel.title
        if (self.isPlaceholder) { return }
        viewModel.poster?.bind(to: self.img_poster.rx.image).disposed(by: disposeBag)
    }
}
