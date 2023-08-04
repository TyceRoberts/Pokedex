//
//  PokeError.swift
//  Pokedex Capstone
//
//  Created by tyce roberts on 7/16/23.
//

import Foundation

enum PokeError: Error {
    case invalidURL
    case unableToDecode
    case networkError(Error)
    case noData
    case thrownError(String)

    var description: String {
        switch self {

        case .invalidURL:
            return "Invalid URL"
        case .unableToDecode:
            return "Unable to Decode"
        case .networkError(let error):
            return "error: (error.localizedDescription)"
        case .noData:
            return "No Data"
        case .thrownError(let message):
            return "There was an issue. (message)"
        }
    }
}
