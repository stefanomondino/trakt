//
//  PosterGalleryItemView.swift
//  Traktv
//
//  Created by Stefano Mondino on 09/07/17.
//  Copyright © 2017 stefanomondino.com. All rights reserved.
//

import UIKit
import Boomerang
import RxSwift
import Action
import RxCocoa

class PosterGalleryItemView: UIView, ViewModelBindable, EmbeddableView, UICollectionViewDelegateFlowLayout {
    
    var viewModel:ItemViewModelType?
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? PosterGalleryItemViewModel else {
            return
        }
        if (self.isPlaceholder) { return }
        disposeBag = DisposeBag()
        
        self.viewModel = viewModel
        
        self.collectionView.delegate = self
        self.collectionView.bind(to: viewModel)
        
        if let cv = self.collectionView {
            
            
            self.rx.methodInvoked(#selector(scrollViewDidEndDragging(_:willDecelerate:))) //Whenever users stops manual drag
                .startWith([]) //"simulate" an initial drag
                .flatMapLatest {[weak self] _ -> Observable<IndexPath> in
                    let currentIndex = self?.collectionView.indexPathsForVisibleItems.first?.item ?? 0 //get current visible index
                    return Observable<Int>.interval(2, scheduler: MainScheduler.instance).map {  // Timer of 2 seconds on main thread
                        return ($0 + currentIndex + 1) % cv.numberOfItems(inSection: 0) // return previous scrolled index path + 1 + total count of timer iterations. Module this value with total items in collection view to go back to the start when the slide is over
                        }
                        .map { IndexPath(item: $0, section: 0) } // get proper index path
                        .filter { viewModel.model(atIndex: $0) != nil } // discard every useless index path
                        .takeUntil((self?.rx.methodInvoked(#selector(PosterGalleryItemView.scrollViewWillBeginDragging(_:))) ?? .just([])).map{_ in ()}) // whenever user manually start scrolling, stop listening for the timer. It will automatically restart upon drag ending
                }
                .subscribe(onNext:{ //scroll to proper index path
                    cv.scrollToItem(at: $0, at: .centeredHorizontally, animated: true)}
                )
                
                .disposed(by: disposeBag)
        }
        
        viewModel.reload()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.frame.size
    }
    
}
