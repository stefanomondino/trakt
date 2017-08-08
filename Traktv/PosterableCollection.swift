//
//  PosterableCollection.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Foundation
import Boomerang
import RxSwift

class PosterableCollection: ModelType {
    var data:Observable<[Posterable]>
    var title:String
    init(with data:Observable<[Posterable]>, title: String = "") {
        self.title = title
        self.data = data
    }
    convenience init (with items:[Posterable], title:String = "") {
        self.init(with: .just(items), title:title)
    }
}
