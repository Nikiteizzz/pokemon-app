//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func getPokemonsData(resultHandler: @escaping (Result<PokemonData, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func getPokemonsData(resultHandler: @escaping (Result<PokemonData, Error>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20") else { return }
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    resultHandler(.failure(error!))
                }
            }
            if data == nil {
                print("пизда")
                return
            }
            do {
                let pokemonDataObj: PokemonData = try JSONDecoder().decode(PokemonData.self, from: data!)
                DispatchQueue.main.async {
                    resultHandler(.success(pokemonDataObj))
                }
            } catch {
                DispatchQueue.main.async {
                    resultHandler(.failure(error))
                }
            }
        }
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            urlSession.resume()
        }
    }
}
