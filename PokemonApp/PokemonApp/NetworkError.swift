//
//  NetworkError.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 4.11.22.
//

import Foundation

public enum NetworkError {
    case badDecode
    case badData
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badData:
            return NSLocalizedString("Server sent bad data", comment: "Looks like some problems with url")
        case .badDecode:
            return NSLocalizedString("Can't decode data", comment: "Look to decode struct")
        }
    }
}
