//
//  PokeController.swift
//  Pokedex Capstone
//
//  Created by tyce roberts on 6/27/23.
//

import UIKit


//Step 1: Get model ready for decoding
//Step 1.1: Decode a list of pokemon with minimal data
//Step 1.2: Decode individual Pokemon with specific data

//Step 1.3: Send network call for list of Pokemon
//Step 1.4 network request for individual Pokemon
//Step 1.5 Send a sprite network request

struct PokeResponse: Codable {
    var results: [PokeMinimal]
}

struct PokeMinimal: Codable {
    var name: String
    var url: String
}

class PokeController {
    
    static let shared: PokeController = PokeController()
    
    static let baseURL: String = "https://pokeapi.co/api/v2/pokemon/?limit=250"
    //base url
    var pokeMinimals: [PokeMinimal] = []
    
    // `Result` is us declaring what Success and Failure look like, in terms of our network request
    // Success on the left, Failure on the right.
    // If we succeed, we should have an array of PokeMinimal objects.
    // If we fail, we should have a PokeError(an error of our own creation, conforming to `Error`)
    
    func fetchPokes(completion: @escaping (Result<[PokeMinimal], PokeError>) -> Void) {
        
        // Get the URL that we will be accessing (notice this is static, so we access through the Type `PokeController`)
        guard let url = URL(string: PokeController.baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Start a URLSession to send a network request
        // When a session completes, you will have 3 things
        // Some data, an HTTPResponse, or an error
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Check for an error
            if let error = error {
                completion(.failure(.thrownError(error.localizedDescription)))
                return
            }
            
            // Ensure there is data
            guard let data = data else { return completion(.failure(.noData)) }
            
            // Try to decode the data
            do {
                var decodedData = try JSONDecoder().decode(PokeResponse.self, from: data)
                self.pokeMinimals = decodedData.results
                completion(.success(decodedData.results))
                return
            } catch {
                completion(.failure(.unableToDecode))
                return
            }
            
        }.resume()
        
    }
}
