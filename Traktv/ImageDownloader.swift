//
//  Image.swift
//  Maze
//
//  Created by Synesthesia on 16/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Gloss
import Boomerang
import AlamofireImage

struct ImageDownloader {
    
    private static let downloader = {
        // AlamofireImage's downloader
        return AlamofireImage.ImageDownloader()
    }()
    
    static func download(from urlString: String?) -> Observable<UIImage?> {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return .just(nil)
        }
        return ImageDownloader.download(url)
    }
    
    static func  download(_ url: URL) -> Observable<UIImage?> {
        return Observable.create { observer in
            let urlRequest = URLRequest(url: url)
            let receipt = downloader.download(urlRequest) { response in
                if let error =  response.result.error {
                    observer.onError(error)
                }
                if let image = response.result.value {
                    observer.onNext(image)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                if receipt != nil {
                    downloader.cancelRequest(with: receipt!)
                }
            }
        }
    }
    
}
typealias Image = ObservableImageType
protocol ObservableImageType : ModelType {
    func getImage() -> Observable<UIImage?>
}

typealias ObservableImage = Observable<UIImage?>

extension UIImage : ObservableImageType {
    func getImage() -> ObservableImage {
        return .just(self)
    }
}
extension URL : ObservableImageType {
    func getImage() -> Observable<UIImage?> {
        return ImageDownloader.download(self)
    }
}
