//
//  ListableItemViewModel.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class ListableItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = View.listable
    var title: String
    var poster : ObservableImage
    init(model: Posterable) {
        self.model = model
        self.title = model.title
        self.poster = model.poster?.getImage() ?? .just(nil)
    }
}
