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
    func showSuccessAlert(message: String, resultHandler: (()->Void)?)
    func success()
    func showSavedPokemon(pokemon: PokemonSave)
    func showFailAlert(message: String, resultHandler: (()->Void)?)
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
        guard let unwrappedAppCoordinator = appCoordinator else {
            self.internetStatus = false
            self.coreDataManager = coreDataManager
            return
        }
        self.internetStatus = unwrappedAppCoordinator.internetStatus
        self.coreDataManager = coreDataManager
        if internetStatus {
            guard let unwrappedSelectedPokemon = unwrappedAppCoordinator.selectedPokemon else { return }
            getPokemonsCharacteristics(url: unwrappedSelectedPokemon.characteristicsURL )
        } else {
            guard let unwrappedSelectedSavedPokemon = unwrappedAppCoordinator.selectedSavedPokemon else { return }
            view.showSavedPokemon(pokemon: unwrappedSelectedSavedPokemon)
        }
    }
    
    func getPokemonsCharacteristics(url: URL) {
        networkManager.getData(url: url) {
            [weak self] result in
            guard let unwrappedSelf = self else { return }
            switch result {
            case .failure(let error):
                unwrappedSelf.view?.showFailAlert(message: error.localizedDescription, resultHandler: nil)
            case .success(let data):
                unwrappedSelf.networkManager.getPokemonsCharacteristics(data: data) {
                    result in
                    switch result {
                    case .success(let pokemonCharacteristics):
                        unwrappedSelf.pokemonCharacteristics = pokemonCharacteristics
                        let pokemonSaveData = unwrappedSelf.coreDataManager.getEntityObj()
                        pokemonSaveData.name = unwrappedSelf.pokemonCharacteristics?.name
                        pokemonSaveData.weight = Int64((unwrappedSelf.pokemonCharacteristics?.weight) ?? 0)
                        pokemonSaveData.height = Int64((unwrappedSelf.pokemonCharacteristics?.height) ?? 0)
                        unwrappedSelf.appCoordinator?.savedPokemons?.append(pokemonSaveData)
                        unwrappedSelf.coreDataManager.savePokemon() {
                            result in
                            switch result {
                            case .success(let message):
                                unwrappedSelf.view?.showSuccessAlert(message: message, resultHandler: nil)
                                unwrappedSelf.view?.success()
                            case .failure(let error):
                                unwrappedSelf.view?.showFailAlert(message: error.localizedDescription, resultHandler: nil)
                            }
                        }
                        unwrappedSelf.view?.success()
                    case .failure(let error):
                        unwrappedSelf.view?.showFailAlert(message: error.localizedDescription, resultHandler: nil)
                    }
                }
            }
        }
    }
    
    func getPokemonImage() {
        guard let unwrappedPokemonCharacteristics = pokemonCharacteristics else {
            self.view?.showFailAlert(message: "Error while getting pokemon characteristics!", resultHandler: nil)
            return
        }
        guard let url = URL(string: "https://img.pokemondb.net/artwork/\(unwrappedPokemonCharacteristics.name).jpg") else {
            self.view?.showFailAlert(message: "Error while getting pokemon characteristics!", resultHandler: nil)
            return
        }
        networkManager.getData(url: url) {
            [weak self] result in
            guard let unwrappedSelf = self else { return }
            switch result {
            case .success(let data):
                unwrappedSelf.networkManager.getPokemonImage(data: data) {
                    result in
                    switch result {
                        case .success(let image):
                        unwrappedSelf.view?.setImage(image: image)
                    case .failure(let error):
                        unwrappedSelf.view?.showFailAlert(message: error.localizedDescription, resultHandler: nil)
                    }
                }
            case .failure(_):
                unwrappedSelf.view?.showFailAlert(message: "Error while getting pokemon's image!", resultHandler: nil)
            }
        }
    }
}
