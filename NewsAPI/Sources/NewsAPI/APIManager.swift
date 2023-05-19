//
//  APIManager.swift
//  NewsAPI
//
//  Created by Emine Sinem on 19.05.2023.
//

import Foundation


public class APIManager {
    let apiKey = "ws8eBdyNMkVjdEk8GlkA2m7hQLSA5l86"
    
    public init() {
        
    }
    
    public func getData(section: String, completion: @escaping ([Article], Error?) -> ()) {
        
        let url = URL(string: "https://api.nytimes.com/svc/topstories/v2/\(section).json?api-key=\(apiKey)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                completion([], error)
            } else {
                if let data = data {
                    do {
                        let articleResponse = try JSONDecoder().decode(ArticleResponse.self, from: data)
                        
                        // Filter articles without data
                        let articles = articleResponse.results.filter {
                            guard let title = $0.title,
                                  let abstract = $0.abstract else {
                                return false
                            }
                            
                            return title.count > 0 && abstract.count > 0
                        }
                        
                        completion(articles, nil)
                    } catch {
                        completion([], error)
                    }
                }
            }
        }
        task.resume()
    }
}
