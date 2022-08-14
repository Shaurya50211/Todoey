//
//  ViewController.swift
//  Todoey
//
//  Created by Shaurya Gupta on 2022-07-29.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory?.name
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Changing the nav bar appearance Start
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(named: "navbar")
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
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { cancel in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // What will happen when the user clicks Add Item on out UIAlertAction
            
            if textField.text == "" {
                textField.placeholder = "Please enter something..."
            } else if let text = textField.text {
                
                // MARK: - Create in CRUD
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = text
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving todoItems \(error)")
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Eg. Attend dentist appointment"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Read in CRUD
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: false)
        
        tableView.reloadData()
    }
}

// MARK: - Search Bar Delegate
extension TodoListViewController: UISearchBarDelegate {
    
    func searchButtonClick(_ searchBar: UISearchBar) {
        
        // MARK: - Query our Data
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                // Dismiss Keyboard
                searchBar.resignFirstResponder()
            }
        } else {
            // Call the function "searchButtonClick" so there is a live search
            searchButtonClick(searchBar)
            tableView.reloadData()
        }
    }
}



// MARK: - Tableview Datasource Methods

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if let item = todoItems?[indexPath.row] {
            content.text = item.title
            cell.contentConfiguration = content
            
            // Ternary Operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            // Remove or add checkmark
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            content.text = "No items added yet!"
        }
        return cell
    }
    
    // MARK: - Table view Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK: - Update in CRUD
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // Delete data
                    // realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
