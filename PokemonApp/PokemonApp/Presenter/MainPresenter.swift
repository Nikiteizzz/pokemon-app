//
//  AppPresenter.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    var appCoordinator: CoordinatorProtocol? { get set }
    func success()
    func error(errorMessgae: String)
}

protocol MainViewPresenterProtocol: AnyObject {
    var pokemonsData: PokemonData? { get set }
    init(view: MainViewProtocol, networkManager: NetworkManagerProtocol)
    func getPokemons()
}

class MainPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    let networkManager: NetworkManagerProtocol!
    var pokemonsData: PokemonData?
    
    required init(view: MainViewProtocol, networkManager: NetworkManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
        getPokemons()
    }
    
    func getPokemons() {
        networkManager.getPokemonsData(successHandler: {
            result in
            DispatchQueue.main.async {
                self.pokemonsData = result
                self.view?.appCoordinator!.pokemonsData = result
                self.view?.success()
            }
        }, errorHandler: {
            message in
            DispatchQueue.main.async {
                self.view?.error(errorMessgae: message)
            }
        })
    }
    
}
