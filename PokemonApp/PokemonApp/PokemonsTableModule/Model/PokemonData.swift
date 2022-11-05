//
//  PokemonData.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

import Foundation


struct Pokemon: Codable, Equatable {
    var name: String
    var characteristicsURL: URL
    enum CodingKeys: String, CodingKey {
        case name
        case characteristicsURL = "url"
    }
}

struct PokemonData: Codable, Equatable {
    var countOfPokemons: Int
    var nextURL: URL?
    var prevURL: URL?
    var listOfPokemons: [Pokemon]
    enum CodingKeys: String, CodingKey {
        case countOfPokemons = "count"
        case nextURL = "next"
        case prevURL = "previous"
        case listOfPokemons = "results"
    }
}
