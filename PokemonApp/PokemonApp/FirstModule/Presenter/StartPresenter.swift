//
//  AppPresenter.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

import Foundation

protocol StartViewProtocol: AnyObject {
    func success()
    func error(errorMessgae: String)
}

protocol StartViewPresenterProtocol: AnyObject {
    var pokemonsData: PokemonData? { get set }
    var appCoordinator: CoordinatorProtocol? { get set }
    init(view: StartViewProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol)
    func getPokemons(urlStr: String)
    func getPokemons(url: URL)
    func getNextList()
    func getPrevList()
    func showPokemonCharacteristics(pokemon: Pokemon)
}

class StartPresenter: StartViewPresenterProtocol {
    
    weak var view: StartViewProtocol?
    var networkManager: NetworkManagerProtocol?
    var pokemonsData: PokemonData?
    weak var appCoordinator: CoordinatorProtocol?
    
    required init(view: StartViewProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.appCoordinator = coordinator
        getPokemons(urlStr: "https://pokeapi.co/api/v2/pokemon")
    }
    
    func getPokemons(urlStr: String) {
        guard let downloadURL = URL(string: urlStr) else { return }
        networkManager!.getPokemonsData(url: downloadURL) {
            [weak self] result in
            switch result {
            case .failure(let error):
                self!.view?.error(errorMessgae: error.errorDescription!)
            case .success(let pokemonData):
                self!.pokemonsData = pokemonData
                self!.view?.success()
            }

        }
    }
    
    func getPokemons(url: URL) {
        networkManager!.getPokemonsData(url: url) {
            [weak self] result in
            switch result {
            case .failure(let error):
                self!.view?.error(errorMessgae: error.errorDescription!)
            case .success(let pokemonData):
                self!.pokemonsData = pokemonData
                self!.view?.success()
            }

        }
    }
    
    func getNextList() {
        guard let url = pokemonsData?.nextURL else  { return }
        getPokemons(url: url)
    }
    
    func getPrevList() {
        guard let url = pokemonsData?.prevURL else  { return }
        getPokemons(url: url)
    }
    
    func showPokemonCharacteristics(pokemon: Pokemon) {
        appCoordinator?.selectedPokemon = pokemon
        appCoordinator?.goToCharacteristicsVC()
    }
}
