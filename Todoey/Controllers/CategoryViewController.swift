//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shaurya Gupta on 2022-08-10.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        // Changing the nav bar appearance Start
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(named: "navbar")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        // Changing the nav bar appearance End
        
        
        
    }
    
    // MARK: - Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if textField.text != "" {
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            } else {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Eg. Work"
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = categories?[indexPath.row].name ?? "No categories added yet!"
            cell.contentConfiguration = content
        }
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVS = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVS.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    // Mark: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}
