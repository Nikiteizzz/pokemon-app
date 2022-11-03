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
    func showFailAlert(message: String, resultHandler: (()->Void)?)
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
        guard let unwrappedNetworkManager = networkManager else { return }
        unwrappedNetworkManager.getPokemonsData(url: downloadURL) {
            [weak self] result in
            guard let unwrappedSelf = self else { return }
            switch result {
            case .failure(_):
                unwrappedSelf.internerStatus = false
                unwrappedSelf.appCoordinator?.internetStatus = false
                unwrappedSelf.view?.error(errorMessgae: "Saved data will be used")
            case .success(let pokemonData):
                unwrappedSelf.pokemonsData = pokemonData
                unwrappedSelf.view?.success()
            }

        }
    }
    
    func getPokemons(url: URL) {
        guard let unwrappedNetworkManager = networkManager else { return }
        unwrappedNetworkManager.getPokemonsData(url: url) {
            [weak self] result in
            guard let unwrappedSelf = self else { return }
            switch result {
            case .failure(_):
                unwrappedSelf.internerStatus = false
                unwrappedSelf.appCoordinator?.internetStatus = false
                unwrappedSelf.view?.error(errorMessgae: "Saved data will be used")
            case .success(let pokemonData):
                unwrappedSelf.pokemonsData = pokemonData
                unwrappedSelf.view?.success()
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
            self.view?.showFailAlert(message: "Error while getting saved data", resultHandler: nil)
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
