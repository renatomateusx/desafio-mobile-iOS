//
//  MarvelDBServiceProtocol.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//


import UIKit

protocol MarvelServiceProtocol {
    
    func fetchPersonCollection(by collectionType: MarvelCollection, successHandler: @escaping (_ response: MarvelResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    
    func fetchPerson(id: Int, successHandler: @escaping (_ response: MarvelDetail) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
    
    func searchPerson(query: String, successHandler: @escaping (_ response: MarvelResponse) -> Void, errorHandler: @escaping(_ error: Error) -> Void)
}

public enum MarvelCollection: String, CustomStringConvertible, CaseIterable {
    case upcoming
    case popular
    case topRated = "top_rated"
    
    public init?(index: Int) {
        switch index {
        case 0:
            self = .upcoming
        case 1:
            self = .popular
        case 2:
            self = .topRated
        default:
            return nil
        }
    }
    
    public var description: String {
        switch self {
        case .upcoming:
            return "Upcoming"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        }
    }
}

public enum MDError: Error {
    case requestError(Error)
    case invalidResponse
    case serializationError
    case noData
}

