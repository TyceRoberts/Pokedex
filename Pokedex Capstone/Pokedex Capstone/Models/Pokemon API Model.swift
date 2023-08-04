//
//  Pokemon Model.swift
//  Pokedex Capstone
//
//  Created by tyce roberts on 6/20/23.
//

import Foundation


struct PokemonListResponse: Decodable {
    var results: [PokemonModel]
}

struct PokemonModel: Codable {
    var name: String = ""
    var url: String = ""

} //End of struct

struct PokemonDataUrl: Codable {
    let name: String
    let sprites: Sprites
    let stats: [Stats]
    let types: [Types]
    // If you want to include moves, please provide the structure of the "moves" field
}

struct Sprites: Codable {
    let front_default: String
}

struct Stats: Codable {
    let base_stat: Int
    let effort: Int
    let stat: StatDetail
}

struct StatDetail: Codable {
    let name: String
    let url: String
}

struct Types: Codable {
    let slot: Int
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
    let url: String
}


struct Name {
    var name: String = ""
    //Using struct to identify the different stats such as Speed, Attack, Defense, etc.
} //End of struct
