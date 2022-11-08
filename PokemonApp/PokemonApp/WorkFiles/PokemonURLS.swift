//
//  PokemonURLS.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 7.11.22.
//

import Foundation

struct PokemonURLS {
    static let mainList = "https://pokeapi.co/api/v2/pokemon/"
    static func image(name: String) -> String {
        return "https://img.pokemondb.net/artwork/" + name + ".jpg"
    }
}
