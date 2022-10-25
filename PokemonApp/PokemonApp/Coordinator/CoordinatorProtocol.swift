//
//  CoordinatorProtocol.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 23.10.22.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    var pokemonsData: PokemonData? { get set }
    func start()
}

