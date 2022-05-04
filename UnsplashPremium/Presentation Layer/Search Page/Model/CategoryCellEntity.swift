//
//  CategoryCellEntity.swift
//  UnsplashPremium
//
//  Created by Abdurakhman on 03.05.2022.
//

import Foundation

struct CategoryCellEntity: Hashable, Decodable {
    var id: Int
    var full: String
    var regular: String
    var small: String
    var title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
