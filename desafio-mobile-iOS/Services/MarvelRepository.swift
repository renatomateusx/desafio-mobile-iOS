//
//  MarvelRepository.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//


import Alamofire

class MarvelRepository: MarvelServiceProtocol {
   

    public static let shared = MarvelRepository()
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    fileprivate func fetchCodableEntity<T: Codable>(from request: MarvelRequest, successHandler: @escaping (T) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        AF.request(request)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let rsp = try self.jsonDecoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            successHandler(rsp)
                        }
                    } catch {
                        print(error)
                        DispatchQueue.main.async {
                            errorHandler(MDError.serializationError)
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        errorHandler(MDError.requestError(error))
                    }
                }
        }
    }
    
    func configureCache() {
        let aURLCache = URLCache(
            memoryCapacity: 20 * 1024 * 1024, // 20 MB
            diskCapacity: 100 * 1024 * 1024,  // 100 MB
            diskPath: "org.tohr.marvel"
        )
        URLCache.shared = aURLCache
    }
    
    func fetchPersonCollection(by collectionType: MarvelCollection, successHandler: @escaping (MarvelResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        fetchCodableEntity(from: MarvelRequest.collection(collectionType), successHandler: successHandler, errorHandler: errorHandler)
    }
    
    func fetchPerson(id: Int, successHandler: @escaping (MarvelDetail) -> Void, errorHandler: @escaping (Error) -> Void) {
        fetchCodableEntity(from: MarvelRequest.fetchPersonByID(id), successHandler: successHandler, errorHandler: errorHandler)
    }
    
    func searchPerson(query: String, successHandler: @escaping (MarvelResponse) -> Void, errorHandler: @escaping (Error) -> Void) {
        fetchCodableEntity(from: MarvelRequest.searchByText(query), successHandler: successHandler, errorHandler: errorHandler)
    }
}

