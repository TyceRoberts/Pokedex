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
                
                // Delete all existing Pokémon data to prevent duplicates
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Pokemon"))
                do { try context.execute(deleteRequest) } catch { print("Failed to delete existing Pokémon") }
                
                // Save new Pokémon names
                for poke in pokes {
                    let newPokemon = NSManagedObject(entity: entity, insertInto: context)
                    newPokemon.setValue(poke.name, forKey: "name")
                }
                
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not save. (error), (error.userInfo)")
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
        // Get the selected Pokemon
        let selectedPokemon = dataSource.pokemon[indexPath.row]
        
        // Get the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if it's different
        
        // Create an instance of the detail view controller from the storyboard
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController {
            // Pass the selected Pokemon to the detail view controller
            detailViewController.pokemon = selectedPokemon
            
            // Present the detail view controller
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
