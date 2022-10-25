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
    var networkManager: NetworkManagerProtocol?
    var pokemonsData: PokemonData?
    
    required init(view: MainViewProtocol, networkManager: NetworkManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
        getPokemons()
    }
    
    func getPokemons() {
        networkManager!.getPokemonsData() {
            result in
            switch result {
            case .failure(let error):
                self.view?.error(errorMessgae: error.localizedDescription)
            case .success(let pokemonData):
                self.pokemonsData = pokemonData
                self.view?.success()
            }
            
        }
    }
    
}
