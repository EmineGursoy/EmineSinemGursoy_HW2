//
//  Article.swift
//  NewsApp
//
//  Created by Emine Sinem on 11.05.2023.
//

import Foundation

struct Article: Decodable {
    let title: String?
    let byline: String?
    let abstract: String?
    let url: URL?
    let multimedia: [Multimedia]?
}

struct Multimedia: Decodable {
    let url: URL?
}
