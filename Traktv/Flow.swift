//
//  Flow.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import UIKit
import Action

enum FlowType {
    case lines
    case grid
    case backdrops
    
    var itemsPerLine : Int {
        switch self {
        case .grid : return 3
        default : return 1
        }
    }
    var spacing: CGFloat {
        return 0
    }
    var insets:UIEdgeInsets {
        return UIEdgeInsetsMake(spacing, spacing, spacing, spacing)
    }
    var itemAspectRatio : CGFloat? {
        switch self {
        case .grid : return 75/50
        case .backdrops: return 25/100
        default : return nil
        }
    }
}


class FlowDelegate : NSObject, UICollectionViewDelegateFlowLayout {
    private weak var action:  Action<Input,Output>?
    private var type:FlowType
    init(with type:FlowType,  action:Action<Input,Output>? = nil) {
        
        self.type = type
        self.action = action
        super.init()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return type.spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return type.spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return type.insets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let aspectRatio = type.itemAspectRatio else {
            return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: type.itemsPerLine)
    
        }
        
        let w = collectionView.autoWidthForItemAt(indexPath:indexPath, itemsPerLine:type.itemsPerLine)
        return CGSize(width:w, height: w * aspectRatio)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        action?.execute(.item(indexPath))
    }
}
