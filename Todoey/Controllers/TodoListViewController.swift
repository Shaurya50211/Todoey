//
//  ViewController.swift
//  Todoey
//
//  Created by Shaurya Gupta on 2022-07-29.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    
    var itemArray = [Item]().self
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Changing the nav bar appearance Start
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        if #available(iOS 15.0, *) {
            appearance.backgroundColor = UIColor(named: "navbar")
        } else {
            appearance.backgroundColor = .systemBlue
        }
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        // Changing the nav bar appearance End
        
        loadItems()
    }
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // What will happen when the user clicks Add Item on out UIAlertAction
            
            if textField.text == "" {
                textField.placeholder = "Please enter something..."
            } else if let text = textField.text{
                
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
}



// MARK: - Tableview Datasource Methods

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        cell.contentConfiguration = content
        
        // Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        // Remove or add checkmark
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
}


// MARK: - TableView Delegate Methods

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // Sets the done property to the opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

