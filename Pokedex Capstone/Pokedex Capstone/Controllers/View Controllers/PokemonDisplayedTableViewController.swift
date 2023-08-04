//
//  PokemonDisplayedTableViewController.swift
//  Pokedex Capstone
//
//  Created by tyce roberts on 7/16/23.
//

import UIKit
import CoreData

class PokemonDisplayedTableViewController: UITableViewController {
    
    //Mark: - Properties
    
    let dataSource = PokemonDataSource()
    
    
    //MARK: - Lifecycle Functions (Override Functions)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call our Pokemon fetch function
        fetchPokemon()
        
        //Sort data in the TableView
        self.tableView.dataSource = self.dataSource
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
        request.returnsObjectsAsFaults = false
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try context.fetch(request)
            self.dataSource.pokemon = result as! [NSManagedObject]
            self.tableView.reloadData()
        } catch {
            print("Failed")
        }
        
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView()
        
    } // End of View did Load
    
    func fetchPokemon() {
        PokeController.shared.fetchPokes { result in
            switch result {
            case .success(let pokes):
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Pokemon", in: context)!
                
                // Delete existing Pokémon data
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Pokemon"))
                do { try context.execute(deleteRequest) } catch { print("Failed to delete existing Pokémon") }
                
                // Save new Pokémon names and sprites
                for poke in pokes {
                    let newPokemon = NSManagedObject(entity: entity, insertInto: context)
                    newPokemon.setValue(poke.name, forKey: "name")
                    newPokemon.setValue(poke.url, forKey: "url")
                }
                
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
                // Fetch updated Pokémon data
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
                do {
                    let result = try context.fetch(request)
                    self.dataSource.pokemon = result as! [NSManagedObject]
                    self.tableView.reloadData()
                } catch {
                    print("Failed to fetch Pokémon")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }//End of Function

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected Pokemon as an NSManagedObject
        let selectedPokemon = dataSource.pokemon[indexPath.row]

        // Use Key-Value Coding to get the "url" attribute as a String
        if let urlString = selectedPokemon.value(forKey: "url") as? String {
            // Fetch Pokemon details using the URL
            PokeController.shared.fetchPokemonDetails(url: urlString) { result in
                DispatchQueue.main.async { // Make sure UI updates happen on the main thread
                    switch result {
                    case .success(let details):
                        print("Successfully fetched details for \(details.name)")

                        // Get the storyboard
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)

                        // Create an instance of the detail view controller from the storyboard
                        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController {
                            // Pass the selected Pokemon details to the detail view controller
                            detailViewController.pokemonDetails = details

                            // Present the detail view controller
                            self.navigationController?.pushViewController(detailViewController, animated: true)
                        }

                    case .failure(let error):
                        print("Failed to fetch details: \(error)")
                        // Handle error, perhaps by showing an alert to the user
                    }
                }
            }
        } else {
            print("Failed to retrieve URL for selected Pokemon")
        }
    } //End of func


    
    
    
}//End of class
