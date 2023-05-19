//
//  Models.swift
//  NewsAPI
//
//  Created by Emine Sinem on 19.05.2023.
//

import Foundation


// The response object from the API is modeled
struct ArticleResponse: Decodable {
    let results: [Article]
    
    enum CodingKeys: CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let throwables = try container.decode([Throwable<Article>].self, forKey: .results)
        self.results = throwables.compactMap { $0.value }
    }
}

enum Throwable<T: Decodable>: Decodable {
    case success(T)
    case failure(Error)

    init(from decoder: Decoder) throws {
        do {
            let decoded = try T(from: decoder)
            self = .success(decoded)
        } catch let error {
            self = .failure(error)
        }
    }
}

extension Throwable {
    var value: T? {
        switch self {
        case .failure(_):
            return nil
        case .success(let value):
            return value
        }
    }
}
