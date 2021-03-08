//
//  SearchMovieViewModel.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import Foundation
import RxSwift
import RxCocoa

public struct SearchPersonViewModelInputs {
    let marvelRepository: MarvelServiceProtocol
    let query: Driver<String>
}

public protocol SearchPersonViewModelOutputs{
    var persons: Driver<[Marvel]> { get }
    var isFetching: Driver<Bool> { get }
    var info: Driver<String?> { get }
    var hasInfo: Bool { get }
    var numberOfPersons: Int { get }
    func viewModelItemForMarvel(at index: Int) -> MarvelCollectionItemViewModel?
    func viewModelDetailForMarvel(at index: Int) -> MarvelDetailViewModel?
}

public protocol SearchPersonViewModelType {
    init(_ inputs: SearchPersonViewModelInputs)
    var outputs: SearchPersonViewModelOutputs { get }
}

public final class SearchPersonViewModel: SearchPersonViewModelType, SearchPersonViewModelOutputs {
    private let inputs: SearchPersonViewModelInputs
    private let disposeBag = DisposeBag()
    private let _persons = BehaviorRelay<[Marvel]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _info = BehaviorRelay<String?>(value: nil)
    
    fileprivate enum UIMessages {
        static let searchMessage: String = "Search your favorite marvel persons"
        static let notFound: String = "No results found for: "
        static let error: String = "Oops, there was an error when fetching data: \nPlease, check your connection and try again"
    }
    
    public init(_ inputs: SearchPersonViewModelInputs) {
        self.inputs = inputs
        inputs.query.throttle(.seconds(1)).distinctUntilChanged().drive(onNext: { [weak self] (queryString) in
            self?.searchPerson(query: queryString)
            if queryString.isEmpty {
                self?._persons.accept([])
                self?._info.accept(UIMessages.searchMessage)
            }
        }).disposed(by: disposeBag)
    }
    
    public var outputs: SearchPersonViewModelOutputs {
        return self
    }
    
    public var persons: Driver<[Marvel]> {
        return _persons.asDriver()
    }
    
    public var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    public var info: Driver<String?> {
        return _info.asDriver()
    }
    
    public var hasInfo: Bool {
        return _info.value != nil
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
        let vmInput = MarvelDetailViewModelInputs(persons: _persons.value[index], marvelRepository: inputs.marvelRepository)
        return MarvelDetailViewModel(vmInput)
    }
    
    private func searchPerson(query: String?){
        guard let query  = query, !query.isEmpty else {
            _info.accept(UIMessages.searchMessage)
            return
        }
        
        _isFetching.accept(true)
        _persons.accept([])
        _info.accept(nil)
        
        inputs.marvelRepository.searchPerson(query: query, successHandler: {[weak self] (response) in
            self?._isFetching.accept(false)
            if response.data.total == 0 {
                self?._info.accept(UIMessages.notFound + "\(query)")
            }
            self?._persons.accept(Array(response.data.results.prefix(5)))
            
        }) {[weak self] (error) in
            self?._isFetching.accept(false)
            self?._info.accept(UIMessages.error)
        }
    }
    
    
    
    
}

