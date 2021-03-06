//
//  PosterItemViewModel.swift
//  Maze
//
//  Created by Stefano Mondino on 25/06/17.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class PosterItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = View.poster
    var poster : ObservableImage
    init(model: Image) {
        self.model = model
        poster = model.getImage()
    }
    init (with posterable: Posterable) {
        self.model = posterable
        self.poster = posterable.poster?.getImage() ?? UIImage().getImage()
    }
}
