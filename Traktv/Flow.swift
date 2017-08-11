//
//  Flow.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/08/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import UIKit
import Action

struct FlowSettings {
    var itemsPerLine: (IndexPath) -> (Int)
    var spacing:Float
    var insets:UIEdgeInsets
    var itemAspectRatio:Float?
    var isHorizontal : Bool =  false
    
    
    init (itemsPerLine:Int, spacing:Float,  insets:UIEdgeInsets, itemAspectRatio:Float?, isHorizontal: Bool = false) {
        self.itemsPerLine = {_ in return itemsPerLine}
        self.itemAspectRatio = itemAspectRatio
        self.spacing = spacing
        self.insets = insets
        self.isHorizontal = isHorizontal
    }
    
}

enum FlowType {
    case lines
    case grid
    case backdrops
    case horizontal
    case custom(FlowSettings)
    
    func modifying( itemsPerLine:((IndexPath) ->  (Int))? = nil, spacing:Float? = nil , insets:UIEdgeInsets? = nil,  itemAspectRatio:Float? = nil) -> FlowType {
        var settings = self.settings
        if let itemsPerLine = itemsPerLine { settings.itemsPerLine =  itemsPerLine }
        if let spacing = spacing  { settings.spacing = spacing }
        if let insets = insets { settings.insets = insets }
        if let itemAspectRatio = itemAspectRatio { settings.itemAspectRatio = itemAspectRatio }
        return .custom(settings)
    }
    
    var settings:FlowSettings {
        switch self {
        case .lines : return FlowSettings(itemsPerLine: 1, spacing : 0, insets:UIEdgeInsets.zero, itemAspectRatio : nil)
        case .grid : return FlowSettings(itemsPerLine: 3, spacing : 0, insets:UIEdgeInsets.zero, itemAspectRatio : 75/50)
        case .backdrops : return FlowSettings(itemsPerLine: 1, spacing : 0, insets:UIEdgeInsets.zero, itemAspectRatio : 25/100)
        case .horizontal : return FlowSettings(itemsPerLine: 1, spacing: 0, insets: .zero, itemAspectRatio: 75/50, isHorizontal:true)
        case .custom (let settings) : return settings
        }
    }
    
}


class FlowDelegate : NSObject, UICollectionViewDelegateFlowLayout {
    private weak var action:  Action<Input,Output>?
    private var settings:FlowSettings
    init(with settings:FlowSettings,  action:Action<Input,Output>? = nil) {
        self.settings = settings
        self.action = action
        super.init()
    }
    convenience init(with type:FlowType,  action:Action<Input,Output>? = nil) {
        self.init(with: type.settings, action: action)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(settings.spacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(settings.spacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return settings.insets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let aspectRatio = settings.itemAspectRatio else {
            if settings.isHorizontal {
                return collectionView.autosizeItemConstrainedToHeight(at: indexPath, itemsPerLine: settings.itemsPerLine(indexPath))
            }
            
            return collectionView.autosizeItemConstrainedToWidth(at: indexPath, itemsPerLine: settings.itemsPerLine(indexPath))
            
        }
        if settings.isHorizontal {
            let h = collectionView.autoHeightForItemAt(indexPath:indexPath, itemsPerLine:settings.itemsPerLine(indexPath))
            return CGSize(width: h / CGFloat(aspectRatio), height: h)
        } else {
            let w = collectionView.autoWidthForItemAt(indexPath:indexPath, itemsPerLine:settings.itemsPerLine(indexPath))
            return CGSize(width:w, height: w * CGFloat(aspectRatio))
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        action?.execute(.item(indexPath))
    }
}
