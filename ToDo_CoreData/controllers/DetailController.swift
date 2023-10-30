//
//  DetailController.swift
//  ToDo_CoreData
//
//  Created by Ebbyy on 10/30/23.
//
//
import UIKit

class DetailController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searhBar: UISearchBar!
    
    var lists = [ToDo]()
    var category: Category? {
        didSet {
            let predicate = NSPredicate(format: "categoryParent.name MATCHES %@", category!.name!)
            lists = CoreData.Shared.loadData(predicate: [predicate])
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searhBar.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboard)))
    }
    
    @objc
    private func resignKeyboard(){
        searhBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "categoryParent.name MATCHES %@", category!.name!)
        let sec_predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        
        lists.removeAll() 
        lists = CoreData.Shared.loadData(predicate: [predicate, sec_predicate])
        tableView.reloadData()
        
        if searchText == "" {
            let predicate = NSPredicate(format: "categoryParent.name MATCHES %@", category!.name!)
            lists = CoreData.Shared.loadData(predicate: [predicate])
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "categoryParent.name MATCHES %@", category!.name!)
        let sec_predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        lists.removeAll()
        lists = CoreData.Shared.loadData(predicate: [predicate, sec_predicate])
        tableView.reloadData()
        
        if searchBar.text! == "" {
            let predicate = NSPredicate(format: "categoryParent.name MATCHES %@", category!.name!)
            lists = CoreData.Shared.loadData(predicate: [predicate])
            tableView.reloadData()
            
            searhBar.resignFirstResponder()
        }
    }
    
    //data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        cell.textLabel?.text = lists[indexPath.row].name
        if lists[indexPath.row].done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lists[indexPath.row].done = !lists[indexPath.row].done
        CoreData.Shared.saveData()
        tableView.reloadData()
    }
    
    //delegate
    
    @IBAction func addToDO(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add todo", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let saveButton = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            if let todo = textField.text, !todo.isEmpty {
                let item = ToDo(context: CoreData.Shared.context)
                item.name = todo
                item.done = false
                item.categoryParent = self.category
                self.lists.append(item)
                CoreData.Shared.saveData()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(saveButton)
        
        present(alert, animated: true)
    }
    
}
