//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol: AnyObject {
    func getPokemonsData(urlStr: String, resultHandler: @escaping (Result <PokemonData, AFError>) -> Void)
    func getPokemonsData(url: URL, resultHandler: @escaping (Result <PokemonData, AFError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func getPokemonsData(urlStr: String, resultHandler: @escaping (Result <PokemonData, AFError>) -> Void) {
        guard let downloadURL = URL(string: urlStr) else { return }
        AF.request(downloadURL).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let pokemonDataObj = try JSONDecoder().decode(PokemonData.self, from: response.data!)
                    resultHandler(.success(pokemonDataObj))
                } catch {
                    print("Ну и чё делать")
//                    resultHandler(.failure(let error))
                }
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
    
    func getPokemonsData(url: URL, resultHandler: @escaping (Result <PokemonData, AFError>) -> Void) {
        AF.request(url).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let pokemonDataObj = try JSONDecoder().decode(PokemonData.self, from: response.data!)
                    resultHandler(.success(pokemonDataObj))
                } catch {
                    print("Ну и чё делать")
//                    resultHandler(.failure(let error))
                }
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
}
