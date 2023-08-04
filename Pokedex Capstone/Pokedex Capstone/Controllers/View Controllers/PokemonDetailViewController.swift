//
//  PokemonDetailViewController.swift
//  Pokedex Capstone
//
//  Created by tyce roberts on 7/31/23.
//

import UIKit
import CoreData

class PokemonDetailViewController: UIViewController {

    var pokemon: NSManagedObject?

        @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var spriteImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!

        var pokemonDetails: PokemonDataUrl? // Adjust this type to match what you're passing

        override func viewDidLoad() {
                super.viewDidLoad()

                updateUI()

            }

    //MARK: - Functions

        private func updateUI() {
            // Ensure that pokemonDetails is not nil
            guard let details = pokemonDetails else { return }

            // Access the sprite URL string directly
            let spriteUrlString = details.sprites.front_default
            guard let spriteUrl = URL(string: spriteUrlString) else {
                print("Invalid sprite URL: (spriteUrlString)")
                return
            }

            URLSession.shared.dataTask(with: spriteUrl) { (data, response, error) in
                if let error = error {
                    print("Error fetching sprite image: (error)")
                    return
                }

                if let data = data {
                    DispatchQueue.main.async {
                        self.spriteImage.image = UIImage(data: data)
                    }
                }
            }.resume()

            // Update the labels with the fetched details
            nameLabel.text = details.name

            // Extract the type names and join them with a comma
            let typeNames = details.types.map { $0.type.name }.joined(separator: ", ")
            typeLabel.text = typeNames

            // Note: Depending on the structure of PokemonDataUrl, you may need to access nested properties
        }//End of func



    }//End of class
