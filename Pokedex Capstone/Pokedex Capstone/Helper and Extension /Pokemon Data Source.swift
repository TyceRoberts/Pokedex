//
//  Pokemon Data Source.swift
//  Pokedex Capstone
//
//  Created by tyce roberts on 7/31/23.
//
import UIKit
import CoreData

class PokemonDataSource: NSObject, UITableViewDataSource {
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return pokemon.count
       }

    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
           let poke = pokemon[indexPath.row]
           cell.textLabel?.text = poke.value(forKeyPath: "name") as? String
           return cell
       }
    
    var pokemon: [NSManagedObject] = []

        func TableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pokemon.count
        }

        func TableView( tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
            let poke = pokemon[indexPath.row]
            cell.textLabel?.text = poke.value(forKeyPath: "name") as? String
            return cell
        }
    }
 // End of Class
