//
//  AppCoordinator.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 23.10.22.
//

import Foundation
import UIKit

class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var pokemonsData: PokemonData?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = StartViewController()
        let networkManager = NetworkManager()
        let presenter = MainPresenter(view: viewController, networkManager: networkManager)
        navigationController.navigationItem.hidesBackButton = true
        viewController.appCoordinator = self
        viewController.mainPresenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}
