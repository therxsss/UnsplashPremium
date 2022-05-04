//
//  DiscoverCellEntity.swift
//  UnsplashPremium
//
//  Created by Abdurakhman on 03.05.2022.
//

import Foundation

struct DiscoverCellEntity: Hashable, Decodable {
    var id: Int
    var username: String
    var regular: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
