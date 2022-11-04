//
//  UnwrapError.swift
//  PokemonApp
//
//  Created by Никита Хорошко on 4.11.22.
//

import Foundation

public enum UnwrapError: Error {
    case unwrapFail
}

extension UnwrapError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unwrapFail:
            return NSLocalizedString("An error occured while unwrapping optional", comment: "Look at guard statemnets")
        }
    }
}
