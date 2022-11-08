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
    func error(error: Error)
    func showFailAlert(message: String, resultHandler: (()->Void)?)
}

protocol StartViewPresenterProtocol: AnyObject {
    var internerStatus: Bool { get set }
    var pokemonsData: PokemonData? { get set }
    var appCoordinator: CoordinatorProtocol? { get set }
    var savedPokemons: [PokemonSave]? { get set }
    var coreDataManager: CoreDataManagerProtocol { get set }
    var networkManager: NetworkManagerProtocol { get set }
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
    
    var internerStatus: Bool = true {
        didSet {
            if internerStatus == true {
                guard let url = URL(string: PokemonURLS.mainList) else {
                    getSavedPokemons()
                    view?.error(error: UnwrapError.unwrapFail)
                    self.appCoordinator?.internetStatus = false
                    return
                }
                self.appCoordinator?.internetStatus = true
                getPokemons(url: url)
            } else {
                getSavedPokemons()
                view?.error(error: NetworkError.disconnected)
                self.appCoordinator?.internetStatus = false
            }
        }
    }
    weak var appCoordinator: CoordinatorProtocol?
    weak var view: StartViewProtocol?
    var networkManager: NetworkManagerProtocol
    var coreDataManager: CoreDataManagerProtocol
    var pokemonsData: PokemonData?
    var savedPokemons: [PokemonSave]?
    
    required init(view: StartViewProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.appCoordinator = coordinator
        self.coreDataManager = coreDataManager
        getSavedPokemons()
        getPokemons(urlStr: PokemonURLS.mainList)
    }
    
    func getPokemons(urlStr: String) {
        guard let downloadURL = URL(string: urlStr) else {
            view?.showFailAlert(message: UnwrapError.unwrapFail.localizedDescription, resultHandler: nil)
            return
        }
        networkManager.getData(url: downloadURL) {
            [weak self] result in
            guard let unwrappedSelf = self else { return }
            switch result {
            case .success(let data):
                unwrappedSelf.networkManager.getPokemonsData(data: data) {
                    result in
                    switch result {
                    case .success(let data):
                        unwrappedSelf.pokemonsData = data
                        unwrappedSelf.view?.success()
                    case .failure(let error):
                        unwrappedSelf.internerStatus = false
                        unwrappedSelf.appCoordinator?.internetStatus = false
                        unwrappedSelf.view?.error(error: error)
                    }
                }
            case .failure(let error):
                unwrappedSelf.internerStatus = false
                unwrappedSelf.appCoordinator?.internetStatus = false
                unwrappedSelf.view?.error(error: error)
            }
        }
    }
    
    func getPokemons(url: URL) {
        networkManager.getData(url: url) {
            [weak self] result in
            guard let unwrappedSelf = self else { return }
            switch result {
            case .success(let data):
                unwrappedSelf.networkManager.getPokemonsData(data: data) {
                    result in
                    switch result {
                    case .success(let data):
                        unwrappedSelf.pokemonsData = data
                        unwrappedSelf.view?.success()
                    case .failure(let error):
                        unwrappedSelf.internerStatus = false
                        unwrappedSelf.appCoordinator?.internetStatus = false
                        unwrappedSelf.view?.error(error: error)
                    }
                }
            case .failure(let error):
                unwrappedSelf.internerStatus = false
                unwrappedSelf.appCoordinator?.internetStatus = false
                unwrappedSelf.view?.error(error: error)
            }
        }
    }
    
    func getSavedPokemons() {
        let context = coreDataManager.getContext()
        let fetchRequest: NSFetchRequest<PokemonSave> = PokemonSave.fetchRequest()
        do {
            try savedPokemons = context.fetch(fetchRequest)
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
