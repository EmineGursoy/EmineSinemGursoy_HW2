//
//  Article.swift
//  NewsApp
//
//  Created by Emine Sinem on 11.05.2023.
//

import Foundation

public struct Article: Decodable {
    public let title: String?
    public let byline: String?
    public let abstract: String?
    public let url: URL?
    public let multimedia: [Multimedia]?
}

public struct Multimedia: Decodable {
    public let url: URL?
}
