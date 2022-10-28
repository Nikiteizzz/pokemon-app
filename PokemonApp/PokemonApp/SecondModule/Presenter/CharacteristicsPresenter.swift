//
//  CharacteristicsPresentor.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 27.10.22.
//

import Foundation
import UIKit
import CoreData

protocol CharacteristicsViewProtocol: AnyObject {
    var appCoordinator: CoordinatorProtocol? { get set }
    var presenter: CharacteristicsViewPresenterProtocol? { get set }
    func success()
    func showSavedPokemon(pokemon: PokemonSave)
    func failed(errorMessage: String)
    func failedPhoto()
    func setImage(image: UIImage?)
}

protocol CharacteristicsViewPresenterProtocol: AnyObject {
    var pokemonCharacteristics: PokemonCharacteristics? { get set }
    var appCoordinator: CoordinatorProtocol? { get set }
    var internetStatus: Bool { get set }
    var coreDataManager: CoreDataManagerProtocol { get set }
    init(view: CharacteristicsViewProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol, coreDataManager: CoreDataManagerProtocol)
    func getPokemonsCharacteristics(url: URL)
    func getPokemonImage()
}

class CharacteristicsViewPresenter: CharacteristicsViewPresenterProtocol {
    weak var appCoordinator: CoordinatorProtocol?
    weak var view: CharacteristicsViewProtocol?
    var internetStatus: Bool = true
    var coreDataManager: CoreDataManagerProtocol
    var pokemonCharacteristics: PokemonCharacteristics?
    var networkManager: NetworkManagerProtocol
    var image: UIImage?
    
    required init(view: CharacteristicsViewProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.appCoordinator = coordinator
        self.internetStatus = appCoordinator!.internetStatus
        self.coreDataManager = coreDataManager
        if internetStatus {
            getPokemonsCharacteristics(url: (appCoordinator?.selectedPokemon?.characteristicsURL)!)
        } else {
            view.showSavedPokemon(pokemon: (appCoordinator?.selectedSavedPokemon)!)
        }
    }
    
    func getPokemonsCharacteristics(url: URL) {
        networkManager.getPokemonsCharacteristics(url: url) {
            [weak self] result in
            switch result {
            case .failure(let error):
                self!.view?.failed(errorMessage: error.errorDescription!)
            case .success(let pokemonCharacteristics):
                self!.pokemonCharacteristics = pokemonCharacteristics
                let pokemonSaveData = self?.coreDataManager.getEntityObj()
                pokemonSaveData!.name = self?.pokemonCharacteristics?.name
                pokemonSaveData!.weight = Int64((self?.pokemonCharacteristics?.weight)!)
                pokemonSaveData!.height = Int64((self?.pokemonCharacteristics?.height)!)
                self?.appCoordinator?.savedPokemons?.append(pokemonSaveData!)
                self?.coreDataManager.savePokemon()
                self!.view?.success()
            }
        }
    }
    
    func getPokemonImage() {
        networkManager.getPokemonImage(pokemonName: pokemonCharacteristics!.name) {
            [weak self] result in
            switch result {
            case .success(let image):
                self!.view?.setImage(image: image)
            case .failure(_):
                self!.view?.failedPhoto()
            }
        }
    }
}
