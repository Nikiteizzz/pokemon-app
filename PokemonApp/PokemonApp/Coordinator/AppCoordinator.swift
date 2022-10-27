//
//  AppCoordinator.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 23.10.22.
//

import Foundation
import UIKit

class AppCoordinator: CoordinatorProtocol {
    var navigationController: CustomizedNavigationController
    var selectedPokemon: Pokemon?
    
    init(navigationController: CustomizedNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = StartViewController()
        let networkManager = NetworkManager()
        let presenter = StartPresenter(view: viewController, networkManager: networkManager, coordinator: self)
        viewController.appCoordinator = self
        viewController.mainPresenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToCharacteristicsVC() {
        let viewController = CharacteristicsViewController()
        let networkManager = NetworkManager()
        let presenter = CharacteristicsViewPresenter(view: viewController, networkManager: networkManager, coordinator: self)
        viewController.appCoordinator = self
        viewController.presenter = presenter
        navigationController.present(viewController, animated: true)
    }
}