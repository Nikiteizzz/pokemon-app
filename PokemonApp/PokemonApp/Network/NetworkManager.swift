//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

import Foundation

protocol NetworkManagerProtocol {
    func getPokemonsData(successHandler: @escaping (PokemonData)->Void, errorHandler: @escaping (String) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    private let pokemonListURL = "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20"
    
    func getPokemonsData(successHandler: @escaping (PokemonData) -> Void, errorHandler: @escaping (String) -> Void) {
        guard let url = URL(string: pokemonListURL) else { return }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) {
            data, _, error in
            if error != nil {
                errorHandler(error!.localizedDescription)
                return
            }
            if data == nil {
                errorHandler("Сервер отправил пустой ответ!")
                return
            }
            do {
                let obj: PokemonData = try JSONDecoder().decode(PokemonData.self, from: data!)
                successHandler(obj)
            } catch {
                errorHandler("Неправильный формат данных!")
            }
        }.resume()
    }
}
