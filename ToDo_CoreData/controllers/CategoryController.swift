//
//  ViewController.swift
//  ToDo_CoreData
//
//  Created by Ebbyy on 10/30/23.
//

import UIKit
import CoreData

class CategoryController: UITableViewController {

    var categoryList = [Category]()
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        categoryList = CoreData.Shared.loadCategory()
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView" {
            if let VC = segue.destination as? DetailController {
                VC.category = selectedCategory!
            }
        }
    }
    
    //datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryList[indexPath.row].name
        return cell
    }
    
    //delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryList[indexPath.row]
        self.performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    @IBAction func addCategory(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let saveButton = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            if let categoryName = textField.text, !categoryName.isEmpty {
                let category = Category(context: CoreData.Shared.context)
                category.name = categoryName
                self.categoryList.append(category)
                CoreData.Shared.saveData()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(saveButton)
        
        present(alert, animated: true)
    }
}
