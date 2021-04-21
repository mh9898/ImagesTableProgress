//
//  Post.swift
//  ImagesTableProgress
//
//  Created by MiciH on 4/21/21.
//

import Foundation

struct Results: Codable {
    let results: [Post]
}

struct PostUrls: Codable {
    let regular: String
    let raw: String
    let full: String
}

struct Post: Codable {
    let id: String
    let description: String?
    let urls: PostUrls
}
