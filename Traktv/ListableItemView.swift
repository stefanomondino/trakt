//
//  ListableItemView.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import UIKit
import Boomerang
import RxSwift
import Action
import RxCocoa

class ListableItemView: UIView, ViewModelBindable, EmbeddableView {
    
    var viewModel:ItemViewModelType?
    @IBOutlet weak var img_poster: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ListableItemViewModel else {
            return
        }
        self.viewModel = viewModel
        
        self.lbl_title.text = viewModel.title
        if (self.isPlaceholder) { return }
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        viewModel.poster.startWith(nil).bind(to: self.img_poster.rx.image).disposed(by: disposeBag)
        
    }
}
