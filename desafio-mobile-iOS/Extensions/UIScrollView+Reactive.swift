//
//  UIScrollView+Reactive.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    public var reachedBottom: Observable<Void> {
        return contentOffset
            .flatMap{
                [unowned base] (contentOffset) -> Observable<Void> in
                
                let visibleHeight = base.frame.height - base.contentInset.top - base.contentInset.bottom
                let y = contentOffset.y + base.contentInset.top
                let threshold = max(0.0, base.contentSize.height - visibleHeight)
                return (y > threshold) ? Observable.just(()) : Observable.empty()
            }
    }
}
