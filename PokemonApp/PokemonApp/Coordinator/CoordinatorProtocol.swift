//
//  CoordinatorProtocol.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 23.10.22.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: CustomizedNavigationController { get set }
    func start()
}

