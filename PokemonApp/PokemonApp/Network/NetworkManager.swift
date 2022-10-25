//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol: AnyObject {
    func getFirstPokemonsData(resultHandler: @escaping (Result <PokemonData, AFError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func getFirstPokemonsData(resultHandler: @escaping (Result <PokemonData, AFError>) -> Void) {
        AF.request("https://pokeapi.co/api/v2/pokemon").responseJSON {
            response in
            switch response.result {
            case .success:
                let pokemonDataObj = try! JSONDecoder().decode(PokemonData.self, from: response.data!)
                resultHandler(.success(pokemonDataObj))
            case .failure(let error):
                resultHandler(.failure(error))
            }
            print(response)
        }
    }
}
