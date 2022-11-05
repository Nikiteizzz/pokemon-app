//
//  PokemonAppTests.swift
//  PokemonAppTests
//
//  Created by Никита Хорошко on 21.10.22.
//

import XCTest
@testable import PokemonApp

final class PokemonAppTests: XCTestCase {
    
    var testNetworkManager: NetworkManager!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class
        try super.setUpWithError()
        testNetworkManager = NetworkManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testNetworkManager = nil
        try super.tearDownWithError()
    }
    
    func testGettingDataFromNetworkIfURLExistAndHTTP() {
        let url = URL(string: "http://numbersapi.com/42")!
        let promise = expectation(description: "Completion handler invoked")
        testNetworkManager.getData(url: url) {
            result in
            switch result {
            case .success(_):
                promise.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testGettingDataFromNetworkIfURLExistAndHTTPS() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        let promise = expectation(description: "Completion handler invoked")
        testNetworkManager.getData(url: url) {
            result in
            switch result {
            case .success(_):
                promise.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testGettingDataFromNetworkIfURLDoesntExist() {
        let url = URL(string: "https://jajajaasdmkasd.com/getApi")!
        let promise = expectation(description: "Completion handler invoked")
        testNetworkManager.getData(url: url) {
            result in
            switch result {
            case .success(_):
                XCTFail("There should be error")
            case .failure(_):
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testGettingPokemonList() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=1")!
        let promise = expectation(description: "Completion handler invoked")
        let testData = PokemonData(
            countOfPokemons: 1154,
            nextURL: URL(string: "https://pokeapi.co/api/v2/pokemon/?offset=1&limit=1")!,
            prevURL: nil,
            listOfPokemons: [Pokemon(name: "bulbasaur", characteristicsURL: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)])
        testNetworkManager.getData(url: url) {
            result in
            switch result {
            case .success(let data):
                self.testNetworkManager.getPokemonsData(data: data) {
                    result in
                    switch result {
                    case .success(let pokemonData):
                        XCTAssertEqual(pokemonData, testData, "These objects must be equal")
                        promise.fulfill()
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testGettingPokemonCharacteristics() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!
        let promise = expectation(description: "Completion handler invoked")
        let detailedTypes = [
            DetailedPokemonType(name: "grass", url: URL(string: "https://pokeapi.co/api/v2/type/12/")!),
            DetailedPokemonType(name: "poison", url: URL(string: "https://pokeapi.co/api/v2/type/4/")!)
        ]
        let testData = PokemonCharacteristics(
            name: "bulbasaur",
            weight: 69,
            height: 7,
            types: [
                PokemonTypes(slot: 1, type: detailedTypes[0]),
                PokemonTypes(slot: 2, type: detailedTypes[1])
            ])
        testNetworkManager.getData(url: url) {
            result in
            switch result {
            case .success(let data):
                self.testNetworkManager.getPokemonsCharacteristics(data: data) {
                    result in
                    switch result {
                    case .success(let pokemonCharacteristics):
                        XCTAssertEqual(pokemonCharacteristics, testData, "These objects must be equal")
                        promise.fulfill()
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [promise], timeout: 10)
    }
}
