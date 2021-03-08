//
//  MarvelServiceRequest.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//



import Alamofire

public enum MarvelRequest: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "https://gateway.marvel.com/v1/public/characters?ts=1&apikey=8ab70220774557466d1358c2e0754ac7&hash=48c93d7f9b3d5cc9207218a45da43107"
        static let apiKey =  ""
    }
    
    case collection(MarvelCollection)
    case fetchPersonByID(Int)
    case searchByText(String)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
//    var path: String {
//        switch self {
//        case .collection(let type):
//            switch type {
//            case .upcoming:
//                return "/movie/upcoming"
//            case .popular:
//                return "/movie/popular"
//            case .topRated:
//                return "/movie/top_rated"
//            }
//        case .fetchPersonByID(let id):
//            return "/movie/\(id)"
//        case .searchByText:
//            return "/search/movie"
//        }
//
//    }
    
//    var parameters: [String: Any] {
//        var params = ["api_key": Constants.apiKey]
//        switch self {
//        case .collection:
//            break
//        case .fetchPersonByID:
//            params["append_to_response"] = "videos,credits"
//        case .searchByText(let q):
//            params["append_to_response"] = "videos,credits"
//            params["language"] = "en-US"
//            params["include_adult"] = "false"
//            params["region"] = "US"
//            params["query"] = q
//        }
//        return params
//    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: nil)
    }
}

