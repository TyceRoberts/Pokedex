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

        override func viewDidLoad() {
            super.viewDidLoad()

            // Check if the Pokemon data is available and then set the name label
            if let pokemon = pokemon {
                nameLabel.text = pokemon.value(forKey: "name") as? String
            }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
