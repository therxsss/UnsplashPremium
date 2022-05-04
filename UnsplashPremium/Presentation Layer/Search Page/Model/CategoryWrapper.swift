//
//  CategoryWrapper.swift
//  UnsplashPremium
//
//  Created by Abdurakhman on 03.05.2022.
//


struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Resulted]
}


struct Resulted: Codable {
    let urls: URLS
}

struct URLS: Codable {
    let full: String
    let regular: String
    let small: String
}

