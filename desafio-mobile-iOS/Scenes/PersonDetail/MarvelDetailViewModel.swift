//
//  MarvelDetailViewModel.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import RxSwift
import RxCocoa

public struct MarvelDetailViewModelInputs {
    let persons: Marvel
    let marvelRepository: MarvelServiceProtocol
}

public protocol MarvelDetailViewModelOutputs {
    var marvelInfo: Driver<String> { get }
    var marvelCast: Driver<[MarvelCast]> { get }
    var topImageURL: URL? { get }
    var title: String? { get }
    var overview: String? { get }
    var numberOfCastPersons: Int { get }
    var numberOfCrewPersons: Int { get }
    func castMemberViewModelForIndex(_ index: Int) -> CastMemberItemViewModel?
}

public protocol MarvelDetailViewModelType {
    init(_ inputs: MarvelDetailViewModelInputs)
    var outputs: MarvelDetailViewModelOutputs { get }
    func fetchPersonDetail()
}

public final class MarvelDetailViewModel: MarvelDetailViewModelType, MarvelDetailViewModelOutputs {
    private let inputs: MarvelDetailViewModelInputs
    private let disposeBag = DisposeBag()
    private let _marvelCast = BehaviorRelay<[MarvelCast]>(value: [])
    private let _marvelInfo = BehaviorRelay<String>(value: "")

    
    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy"
        return $0
    }(DateFormatter())
    
    public init(_ inputs: MarvelDetailViewModelInputs){
        self.inputs = inputs
    }
    
    public var outputs: MarvelDetailViewModelOutputs {
        return self
    }
    
    public var marvelInfo: Driver<String> {
        return _marvelInfo.asDriver()
    }
    
    public var marvelCast: Driver<[MarvelCast]> {
        return _marvelCast.asDriver()
    }
    public var topImageURL: URL? {
        if let thumb = inputs.persons.thumbnail {
            return URL(string: "\(thumb.path).\(thumb.extension)")
        }
        return nil
    }
    
    public var title: String? {
        return inputs.persons.name
    }
    
    public var overview: String? {
        return inputs.persons.description
    }
    
    public var numberOfCastPersons: Int {
        return _marvelCast.value.count
    }
    public var numberOfCrewPersons: Int {
        return _marvelCast.value.count
    }
    
    public func castMemberViewModelForIndex(_ index: Int) -> CastMemberItemViewModel? {
        guard index < _marvelCast.value.count else {
            return nil
        }
        return CastMemberItemViewModel(withMember: _marvelCast.value[index])
    }
    
    
    public func fetchPersonDetail() {
        inputs.marvelRepository.fetchPerson(id: inputs.persons.id, successHandler: { [weak self] (detail) in
            self?._marvelInfo.accept(self?.marvelInfoString(marvelDetail: detail) ?? "")
            //self?._marvelCast.accept(detail.credits?.cast ?? [])
        }, errorHandler: { [weak self] (_) in
            self?._marvelInfo.accept("")
            self?._marvelCast.accept([])
        })
    }
    
    private func marvelInfoString(marvelDetail: MarvelDetail?) -> String {
        var details = "" //2020 • 132 min • 5.9/10 ★
        if let description = marvelDetail?.description {
            details += description
        }
        return details
    }
    
    
    
    
}

