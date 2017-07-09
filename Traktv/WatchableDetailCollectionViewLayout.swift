//
//  WatchableDetailCollectionViewLayout.swift
//  Traktv
//
//  Created by Stefano Mondino on 08/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import UIKit

class DetailsLayout : UICollectionViewFlowLayout {
    class DecorationViewAttributes:UICollectionViewLayoutAttributes {
        var angle:CGFloat = 40
        override func copy(with zone: NSZone? = nil) -> Any {
            let copy = super.copy(with: zone) as! DecorationViewAttributes
            copy.angle = self.angle
            return copy
        }
        override func isEqual(_ object: Any?) -> Bool {
            let equal = super.isEqual(object)
            if let rhs = object as? DecorationViewAttributes {
                return equal && self.angle == rhs.angle
            }
            return equal
        }

    }
    class DecorationView : UICollectionReusableView {
        var angle:CGFloat = 0
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.isOpaque = false
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.isOpaque = false
            
            
        }
        override func draw(_ rect: CGRect) {
            let path = UIBezierPath()
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + angle))
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height))
            path.addLine(to: CGPoint(x: rect.origin.x , y: rect.origin.y + rect.height))
            //            path.addLine(to: CGPoint(x: rect.origin.x , y: rect.origin.y ))
            path.close()
            UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1).setFill()
            path.fill()
            
            self.layer.shadowPath = path.cgPath
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 15
            self.layer.shadowOpacity = 0.2
            
        }
        override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
            super.apply(layoutAttributes)
            self.angle = (layoutAttributes as? DecorationViewAttributes)?.angle ?? 0
            self.setNeedsDisplay()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    func commonInit() {
        self.register(DecorationView.self, forDecorationViewOfKind: "DecorationView")
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        return true
    }
    var proportions:CGFloat = 0.35
    override var collectionViewContentSize: CGSize {
        let padding = (collectionView?.frame.size.width ?? 0) * proportions
        var size = super.collectionViewContentSize
        size.height += padding
        size.height = max(size.height, collectionView?.frame.size.height ?? 0)
        return size
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let padding = (collectionView?.frame.size.width ?? 0) * proportions
        let rect = rect.insetBy(dx: 0, dy: -padding)
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        var poster = self.layoutAttributesForSupplementaryView(ofKind: SupplementaryViewType.poster
            .name, at: IndexPath(item: 0, section: 0))
        
        let scroll = self.collectionView?.contentOffset.y ?? 0
        
        let normalized =  scroll /  (collectionView?.frame.size.height ?? 0)
        
        let proportional = scroll - normalized * padding - padding/1.5
        poster?.zIndex = -2
        poster?.frame = CGRect(x: 0, y: proportional, width: collectionView!.frame.size.width, height: collectionView!.frame.size.height)
        
        var decoration = self.layoutAttributesForDecorationView(ofKind: "DecorationView", at: IndexPath(item: 0, section: 0)) as! DecorationViewAttributes
        decoration.zIndex = -1
        decoration.frame = CGRect(x: 0, y: padding + 40 , width: collectionViewContentSize.width, height: collectionViewContentSize.height*3)
        decoration.angle = max(0, min(50, (50 + normalized * padding)))
        
        let finalAttributes =  attributes.map { attr in
            var a = attr.copy() as! UICollectionViewLayoutAttributes
            var frame = a.frame
            frame.origin.y += padding
            a.frame = frame
            return a
            } + [poster,decoration].flatMap {$0}
        return finalAttributes
    }

    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case "DecorationView" : return DecorationViewAttributes(forDecorationViewOfKind:elementKind, with: indexPath)
        default : return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
        }
    }
    private    var supplementary:[IndexPath:UICollectionViewLayoutAttributes] = [:]
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let item = self.supplementary[indexPath] else {//super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else {
            let newItem = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            supplementary[indexPath] = newItem
            return newItem
        }
        return item
    }
}
