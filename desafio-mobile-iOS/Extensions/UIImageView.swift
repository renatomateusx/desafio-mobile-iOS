//
//  UIImageView.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import UIKit
import Alamofire
import AlamofireImage


// OBS: Alamofire UIImageView extension is powered by the default ImageDownloader instance, which use a
// URLCache instance initialized with a memory capacity of 20 MB and a disk capacity of 150 MB.


extension UIImageView {
    func setImage(fromURL url: URL, animatedOnce: Bool = true, withPlaceholder placeholderImage: UIImage? = nil){
        let hasImage: Bool = (self.image != nil)
        self.af.setImage(withURL: url, placeholderImage: placeholderImage, imageTransition: animatedOnce ? .crossDissolve(0.3) : .noTransition, runImageTransitionIfCached: hasImage)
    }
}
