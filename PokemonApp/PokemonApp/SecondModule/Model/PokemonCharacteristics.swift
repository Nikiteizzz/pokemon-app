//
//  PokemonCharacteristics.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 27.10.22.
//

import Foundation
import UIKit

struct PokemonCharacteristics: Codable {
    var name: String
    var weight: Int
    var height: Int
    var types: [PokemonTypes]
}

struct PokemonTypes: Codable {
    var slot: Int
    var type: DetailedPokemonType
}

struct DetailedPokemonType: Codable {
    var name: String
    var url: URL
}
