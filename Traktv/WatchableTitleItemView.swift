//
//  WatchableTitleItemView.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import UIKit
import Boomerang
import RxSwift
import Action
import RxCocoa

class WatchableTitleItemView: UIView, ViewModelBindable, EmbeddableView {
    
    var viewModel:ItemViewModelType?
    
    @IBOutlet weak var img_poster: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.img_poster.layer.shadowColor = UIColor.black.cgColor
        self.img_poster.layer.shadowRadius = 5
        self.img_poster.layer.shadowOpacity = 0.12
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.img_poster.layer.shadowPath = UIBezierPath(rect: self.img_poster.bounds).cgPath
    }
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? WatchableTitleItemViewModel else {
            return
        }
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        self.lbl_title.text = viewModel.title
        if (self.isPlaceholder) { return }
        viewModel.poster?.bind(to: self.img_poster.rx.image).disposed(by: disposeBag)
    }
}
