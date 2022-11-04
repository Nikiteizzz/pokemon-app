//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 24.10.22.
//

//"https://img.pokemondb.net/artwork/\(pokemonName).jpg"

import Foundation
import Alamofire

protocol NetworkManagerProtocol: AnyObject {
    func getData(url: URL, resultHandler: @escaping (Result<Data, Error>) -> Void)
    func getPokemonsData(data: Data, resultHandler: @escaping (Result <PokemonData, Error>) -> Void)
    func getPokemonsCharacteristics(data: Data, resultHandler: @escaping (Result <PokemonCharacteristics, Error>) -> Void)
    func getPokemonImage(data: Data, resultHandler: @escaping (Result <UIImage, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func getData(url: URL, resultHandler: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url).responseData{
            response in
            switch response.result{
            case .success(let data):
                resultHandler(.success(data))
            case .failure(_):
                resultHandler(.failure(NetworkError.badData))
            }
        }
    }
    
    func getPokemonsCharacteristics(data: Data, resultHandler: @escaping (Result<PokemonCharacteristics, Error>) -> Void) {
        do {
            let pokemonDataObj = try JSONDecoder().decode(PokemonCharacteristics.self, from: data)
            resultHandler(.success(pokemonDataObj))
        } catch {
            resultHandler(.failure(NetworkError.badDecode))
        }
    }
    
    func getPokemonsData(data: Data, resultHandler: @escaping (Result <PokemonData, Error>) -> Void) {
        do {
            let pokemonDataObj = try JSONDecoder().decode(PokemonData.self, from: data)
            resultHandler(.success(pokemonDataObj))
        } catch {
            resultHandler(.failure(NetworkError.badDecode))
        }
    }
    
    func getPokemonImage(data: Data, resultHandler: @escaping (Result <UIImage, Error>) -> Void) {
        guard let image = UIImage(data: data) else { resultHandler(.failure(NetworkError.badDecode)); return }
        resultHandler(.success(image))
    }
}
