//
//  ViewController.swift
//  Todoey
//
//  Created by Shaurya Gupta on 2022-07-29.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    var itemArray = ["Find Doggo", "Buy milk", "Destroy Memory"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Changing the nav bar appearance Start
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        if #available(iOS 15.0, *) {
            appearance.backgroundColor = .systemCyan
        } else {
            appearance.backgroundColor = .systemBlue
        }
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        // Changing the nav bar appearance End
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
                self.itemArray.append(text)
                self.tableView.reloadData()
            }
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}



// MARK: - Tableview Datasource Methods

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if #available(iOS 14.0, *) {
            
            var content = cell.defaultContentConfiguration()
            content.text = itemArray[indexPath.row]
            cell.contentConfiguration = content
        }
        return cell
    }
}


// MARK: - TableView Delegate Methods

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        // Remove or add checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

