//
//  CharacteristicsPresentor.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 27.10.22.
//

import Foundation
import UIKit

protocol CharacteristicsViewProtocol: AnyObject {
    var appCoordinator: CoordinatorProtocol? { get set }
    var presenter: CharacteristicsViewPresenterProtocol? { get set }
    func success()
    func failed(errorMessage: String)
    func failedPhoto()
    func setImage(image: UIImage?)
}

protocol CharacteristicsViewPresenterProtocol: AnyObject {
    var pokemonCharacteristics: PokemonCharacteristics? { get set }
    var appCoordinator: CoordinatorProtocol? { get set }
    init(view: CharacteristicsViewProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol)
    func getPokemonsCharacteristics(url: URL)
    func getPokemonImage()
}

class CharacteristicsViewPresenter: CharacteristicsViewPresenterProtocol {
    
    weak var view: CharacteristicsViewProtocol?
    var pokemonCharacteristics: PokemonCharacteristics?
    var networkManager: NetworkManagerProtocol
    var image: UIImage?
    weak var appCoordinator: CoordinatorProtocol?
    
    required init(view: CharacteristicsViewProtocol, networkManager: NetworkManagerProtocol, coordinator: CoordinatorProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.appCoordinator = coordinator
        getPokemonsCharacteristics(url: (appCoordinator?.selectedPokemon?.characteristicsURL)!)
    }
    
    func getPokemonsCharacteristics(url: URL) {
        networkManager.getPokemonsCharacteristics(url: url) {
            [weak self] result in
            switch result {
            case .failure(let error):
                self!.view?.failed(errorMessage: error.errorDescription!)
            case .success(let pokemonCharacteristics):
                self!.pokemonCharacteristics = pokemonCharacteristics
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
