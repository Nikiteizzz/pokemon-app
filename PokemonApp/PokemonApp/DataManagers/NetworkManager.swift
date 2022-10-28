//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol: AnyObject {
    func getPokemonsData(urlStr: String, resultHandler: @escaping (Result <PokemonData?, AFError>) -> Void)
    func getPokemonsData(url: URL, resultHandler: @escaping (Result <PokemonData?, AFError>) -> Void)
    func getPokemonsCharacteristics(url: URL, resultHandler: @escaping (Result <PokemonCharacteristics?, AFError>) -> Void)
    func getPokemonImage(pokemonName: String, resultHandler: @escaping (Result <UIImage?, AFError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    func getPokemonsCharacteristics(url: URL, resultHandler: @escaping (Result<PokemonCharacteristics?, Alamofire.AFError>) -> Void) {
        AF.request(url).responseJSON {
            response in
            switch response.result {
            case .success:
                let pokemonDataObj = try? JSONDecoder().decode(PokemonCharacteristics.self, from: response.data!)
                resultHandler(.success(pokemonDataObj))
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
    
    func getPokemonsData(urlStr: String, resultHandler: @escaping (Result <PokemonData?, AFError>) -> Void) {
        guard let downloadURL = URL(string: urlStr) else { return }
        AF.request(downloadURL).responseJSON {
            response in
            switch response.result {
            case .success:
                let pokemonDataObj = try? JSONDecoder().decode(PokemonData.self, from: response.data!)
                resultHandler(.success(pokemonDataObj))
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
    
    func getPokemonsData(url: URL, resultHandler: @escaping (Result <PokemonData?, AFError>) -> Void) {
        AF.request(url).responseJSON {
            response in
            switch response.result {
            case .success:
                let pokemonDataObj = try? JSONDecoder().decode(PokemonData.self, from: response.data!)
                resultHandler(.success(pokemonDataObj))
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
    
    func getPokemonImage(pokemonName: String, resultHandler: @escaping (Result <UIImage?, AFError>) -> Void) {
        guard let url = URL(string: "https://img.pokemondb.net/artwork/\(pokemonName).jpg") else { return }
        AF.request(url).responseData {
            data in
            switch data.result {
            case .success:
                let image = UIImage(data: data.data!)
                resultHandler(.success(image))
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
}
