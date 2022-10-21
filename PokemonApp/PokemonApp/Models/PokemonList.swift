//
//  PokemonList.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 21.10.22.
//

import Foundation

struct PokemonList {
    var count: Int
    var nextURL: URL?
    var previousURL: URL?
    var results: [Pokemon]
    enum CodingKeys: String, CodingKey {
        
    }
}
