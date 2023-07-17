//
//  Pokemon Model.swift
//  Pokedex Capstone
//
//  Created by tyce roberts on 6/20/23.
//

import Foundation


struct PokemonListResponse: Decodable {
    var results: [PokemonMinimal]
}

struct PokemonMinimal: Decodable  {
    var name: String
    var url: String
    
} //End of struct

struct PokemonModel: Codable {
    var name: String = ""
    var url: PokemonDataUrl
    
} //End of struct

struct PokemonDataUrl: Codable { 
    var moves: String = ""
    var name: String = ""
    var sprites: String = ""
    var stats: String = ""
    var types: String = ""
} //End of struct

// see which data I want from each different object information.

struct Moves {
    var name: String = ""
    
} //End of struct

struct Sprites {
    var front_default: String = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"
        //displays a basic picture of the pokemon.
    
} //End of struct

struct Stats {
    var base_stat: Int = 0
    var name = Name()
    
} //End of struct

struct Name {
    var name: String = ""
    //Using struct to identify the different stats such as Speed, Attack, Defense, etc.
} //End of struct

struct Types {
    var slot: Int = 0
    var name = Name()
} //End of struct
