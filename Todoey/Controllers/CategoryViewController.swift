//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shaurya Gupta on 2022-08-10.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        alert.addAction(action)
        
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = categories[indexPath.row].name
            cell.contentConfiguration = content
        }
        return cell
    }
    
    // Mark: - Data Manipulation Methods
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error coudn't fetch from context: \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table View Delegate Methods
    
}
