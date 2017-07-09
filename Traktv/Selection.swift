//
//  Selection.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import Boomerang

enum Input : SelectionInput {
    case item(IndexPath)
    case model(ModelType)
    case viewModel(ViewModelType)
    case login
}

enum Output : SelectionOutput {
    case model(ModelType)
    case viewModel(ViewModelType)
    case dismiss
}
