//
//  PokeController.swift
//  Pokedex Capstone
//
//  Created by tyce roberts on 6/27/23.
//

import UIKit

class PokeController {

    static let shared: PokeController = PokeController()

    static let baseURL: String = "https://pokeapi.co/api/v2/pokemon/?limit=250"
    //base url
    var pokeMinimals: [PokemonModel] = []

    // Result is us declaring what Success and Failure look like, in terms of our network request
    // Success on the left, Failure on the right.
    // If we succeed, we should have an array of PokeMinimal objects.
    // If we fail, we should have a PokeError(an error of our own creation, conforming to Error)

    func fetchPokes(completion: @escaping (Result<[PokemonModel], PokeError>) -> Void) {

        // Get the URL that we will be accessing (notice this is static, so we access through the Type PokeController)
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
                var decodedData = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                self.pokeMinimals = decodedData.results
                completion(.success(decodedData.results))
                return
            } catch {
                completion(.failure(.unableToDecode))
                return
            }

        }.resume()
}//End of func

    func fetchPokemonDetails(url: String, completion: @escaping (Result<PokemonDataUrl, PokeError>) -> Void) {
        // Make sure the URL is valid
        guard let validURL = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }

        // Create a data task
        let task = URLSession.shared.dataTask(with: validURL) { (data, response, error) in
            // Handle any error that occurred during the request
            if let error = error {
                completion(.failure(.networkError(error)))
                print("Network error detail: (error)")
                return
            }

            // Make sure we received data
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            // Decode the JSON into the PokemonDataUrl struct
            do {
                let decoder = JSONDecoder()
                let pokemonDetails = try decoder.decode(PokemonDataUrl.self, from: data)
                completion(.success(pokemonDetails))
                print("Pokemon Data successfully decoded")
            } catch {
                // If decoding fails, return the unableToDecode error
                completion(.failure(.unableToDecode))
            }
        }

        // Start the task
        task.resume()
    }//End of func

}//End of class
