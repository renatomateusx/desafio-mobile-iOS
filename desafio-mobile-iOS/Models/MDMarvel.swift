//
//  MDMarvel.swift
//  desafio-mobile-iOS
//
//  Created by Renato Mateus on 08/03/21.
//

import Foundation

public struct MarvelResponse: Codable {
    let data: MarvelResults
}

public struct MarvelResults: Codable {
    let total: Int
    let count: Int
    let results: [Marvel]
}

public struct Marvel: Codable {
    public let id: Int
    public let name: String
    public let description: String?
    public let thumbnail: Thumbnail?
}

public struct Thumbnail: Codable {
    public let path: String
    public let `extension`: String
}

public struct MarvelDetail: Codable {
    public let id: Int
    public let name: String
    public let description: String?
    public let thumbnail: Thumbnail?
}


public struct MarvelCast: Codable {
    public let name: String
    public let description: String
    public let thumbnail: Thumbnail?
}
