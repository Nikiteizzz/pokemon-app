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
    var results: [PokemonInfo]
    enum CodingKeys: String, CodingKey {
        case count
        case nextURL = "next"
        case previousURL = "previous"
        case results
    }
}
