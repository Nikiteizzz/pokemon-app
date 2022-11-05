//
//  PokemonCharacteristics.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 27.10.22.
//

import Foundation
import UIKit

public struct PokemonCharacteristics: Codable, Equatable {
    var name: String
    var weight: Double
    var height: Double
    var types: [PokemonTypes]
}

public struct PokemonTypes: Codable, Equatable {
    var slot: Int
    var type: DetailedPokemonType
}

public struct DetailedPokemonType: Codable, Equatable {
    var name: String
    var url: URL
}
