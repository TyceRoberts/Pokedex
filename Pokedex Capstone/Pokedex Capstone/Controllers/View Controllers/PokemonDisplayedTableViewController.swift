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
        
        // Call our fetch function on our PokeController via the sharedInstance
        PokeController.shared.fetchPokes { result in

            // This is where the result type is very handy
            // On success we can reload our TableView, or whatever you want
            switch result {
            case .success(let pokes):
                print("Looks like we got some Pokes")
                pokes.forEach { poke in
                    //insert code to add poke names to Core Data or Add the names to an Array, save them to a User Default.
                    print(poke.name)
                }
                
                // Print inside the success block
                print(PokeController.shared.pokeMinimals)
                
                // On Failure we can show an error or tell the user there was a problem
            case .failure(let error):
                print(error.localizedDescription)
                
                    }
                }
        // End of fetch request
        
        self.tableView.dataSource = self.dataSource

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
                request.returnsObjectsAsFaults = false
                do {
                    let result = try context.fetch(request)
                    self.dataSource.pokemon = result as! [NSManagedObject]
                    self.tableView.reloadData()
                } catch {
                    print("Failed")
                }
        
        
    } // End of View did Load

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected Pokemon
        let selectedPokemon = dataSource.pokemon[indexPath.row]

        // Create an instance of the detail view controller
        let detailViewController = PokemonDetailViewController()

        // Pass the selected Pokemon to the detail view controller
        detailViewController.pokemon = selectedPokemon

        // Present the detail view controller
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }

    
   
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
