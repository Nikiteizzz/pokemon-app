//
//  AppPresenter.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

import Foundation
import CoreData

protocol StartViewProtocol: AnyObject {
    func success()
    func error(errorMessgae: String)
}

protocol StartViewPresenterProtocol: AnyObject {
    var internerStatus: Bool { get set }
    var pokemonsData: PokemonData? { get set }
    var appCoordinator: CoordinatorProtocol? { get set }
    var savedPokemons: [PokemonSave]? { get set }
    var coreDataManager: CoreDataManagerProtocol? { get set }
    init(view: StartViewProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol, coreDataManager: CoreDataManagerProtocol)
    func getPokemons(urlStr: String)
    func getPokemons(url: URL)
    func getSavedPokemons()
    func getNextList()
    func getPrevList()
    func showPokemonCharacteristics(pokemon: Pokemon)
    func showSavedPokemonCharacteristics(pokemon: PokemonSave)
}

class StartPresenter: StartViewPresenterProtocol {
    
    var internerStatus: Bool = true
    var coreDataManager: CoreDataManagerProtocol?
    weak var view: StartViewProtocol?
    var networkManager: NetworkManagerProtocol?
    var pokemonsData: PokemonData?
    var savedPokemons: [PokemonSave]?
    weak var appCoordinator: CoordinatorProtocol?
    
    required init(view: StartViewProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.appCoordinator = coordinator
        self.coreDataManager = coreDataManager
        getSavedPokemons()
        getPokemons(urlStr: "https://pokeapi.co/api/v2/pokemon")
    }
    
    func getPokemons(urlStr: String) {
        guard let downloadURL = URL(string: urlStr) else { return }
        networkManager!.getPokemonsData(url: downloadURL) {
            [weak self] result in
            switch result {
            case .failure(_):
                self?.internerStatus = false
                self?.appCoordinator?.internetStatus = false
                self!.view?.error(errorMessgae: "Saved data will be used")
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
            case .failure(_):
                self?.internerStatus = false
                self?.appCoordinator?.internetStatus = false
                self!.view?.error(errorMessgae: "Saved data will be used")
            case .success(let pokemonData):
                self!.pokemonsData = pokemonData
                self!.view?.success()
            }

        }
    }
    
    func getSavedPokemons() {
        let context = coreDataManager?.getContext()
        let fetchRequest: NSFetchRequest<PokemonSave> = PokemonSave.fetchRequest()
        do {
            try savedPokemons = context?.fetch(fetchRequest)
            appCoordinator?.savedPokemons = savedPokemons
        } catch _ as NSError {
            print("Error getting saved data")
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
    
    func showSavedPokemonCharacteristics(pokemon: PokemonSave) {
        appCoordinator?.selectedSavedPokemon = pokemon
        appCoordinator?.goToCharacteristicsVC()
    }
}
