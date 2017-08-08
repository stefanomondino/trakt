//
//  GenericViewController.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang
import Action


protocol GenericViewModelType : ListViewModelType {
    var flowType : FlowType { get }
    var action: Action<Input,Output>? { get }
    var title:String { get }
}

extension GenericViewModelType {
    var flowType:FlowType {
        return FlowType.lines
    }
}
extension GenericViewModelType where Self : ViewModelTypeSelectable, Self.Input == Input, Self.Output == Output {
    var action: Action<Input,Output>? {
        return self.selection 
    }
}

class GenericViewController : UIViewController, ViewModelBindable, Collectionable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: GenericViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}
