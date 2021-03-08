//
//  MarvelCollectionViewModel.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import UIKit
import RxSwift
import RxCocoa

public struct MarvelCollectionViewModelInputs{
    let marvelRepository: MarvelServiceProtocol
    let collectionTypeSelected: Driver<MarvelCollection>
}

public protocol MarvelCollectionViewModelOutputs {
    var persons: Driver<[Marvel]> { get }
    var isFetching: Driver<Bool> { get }
    var error: Driver<String?> { get }
    var hasError: Bool { get }
    var numberOfPersons: Int { get }
    func viewModelItemForMarvel(at index: Int) -> MarvelCollectionItemViewModel?
    func viewModelDetailForMarvel(at index: Int) -> MarvelDetailViewModel?
}

public protocol MarvelCollectionViewModelType {
    init(_ inputs: MarvelCollectionViewModelInputs)
    var outputs: MarvelCollectionViewModelOutputs { get }
}

public final class MarvelCollectionViewModel: MarvelCollectionViewModelType, MarvelCollectionViewModelOutputs {

    
    private let inputs: MarvelCollectionViewModelInputs
    private let disposeBag = DisposeBag()
    private let _persons = BehaviorRelay<[Marvel]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    private enum UIMessages {
        static let error: String = "Oops, there was an error fetching data :(\nPlease, check your internet connection and try again"
    }
    public var outputs: MarvelCollectionViewModelOutputs {
        return self
    }
    public init(_ inputs: MarvelCollectionViewModelInputs){
        self.inputs = inputs
        inputs.collectionTypeSelected.drive(onNext: { [weak self] (type) in
            self?.fetchPersons(by: type)
        }).disposed(by: disposeBag)
    }
        
    public var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    public var persons: Driver<[Marvel]>{
        return _persons.asDriver()
    }
    
    public var error: Driver<String?>{
        return _error.asDriver()
    }
    
    public var hasError: Bool {
        return _error.value != nil
    }
    
    public var numberOfPersons: Int {
        return _persons.value.count
    }
    public func viewModelItemForMarvel(at index: Int) -> MarvelCollectionItemViewModel? {
        guard index < _persons.value.count else {
            return nil
        }
        return MarvelCollectionItemViewModel(withPerson: _persons.value[index])
    }
    
    public func viewModelDetailForMarvel(at index: Int) -> MarvelDetailViewModel? {
        guard index < _persons.value.count else {
            return nil
        }
        let vminput = MarvelDetailViewModelInputs(persons: _persons.value[index], marvelRepository: inputs.marvelRepository)
        return MarvelDetailViewModel(vminput)
    }
    
    private func fetchPersons(by collectionType: MarvelCollection){
        _persons.accept([])
       _isFetching.accept(true)
        _error.accept(nil)
        inputs.marvelRepository.fetchPersonCollection(by: collectionType, successHandler: {[weak self] (response) in
                self?._isFetching.accept(false)
            self?._persons.accept(response.data.results)
        }) { [weak self] (error) in
            self?._isFetching.accept(false)
            self?._error.accept(UIMessages.error)
        }
        
    }
    
}


