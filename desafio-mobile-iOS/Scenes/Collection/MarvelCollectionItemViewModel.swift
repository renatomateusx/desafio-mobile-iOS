//
//  MarvelCollectionItemViewModel.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//


import RxSwift

public struct MarvelCollectionItemViewModel {
    private let disposeBag = DisposeBag()
    private let person: Marvel
    
    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy"
        return $0
    }(DateFormatter())
    
    init(withPerson person: Marvel){
        self.person = person
    }
    var posterURL: URL? {
        if let thumb = person.thumbnail {
            return URL(string: "\(thumb.path).\(thumb.extension)")
        }
        return nil
    }
    
    var title: String? {
        return person.name
    }
    var overview: String? {
        return person.description
    }
}
