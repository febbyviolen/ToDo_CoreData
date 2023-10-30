//
//  CoreData.swift
//  ToDo_CoreData
//
//  Created by Ebbyy on 10/30/23.
//

import Foundation
import CoreData
import UIKit

class CoreData {
    static let Shared = CoreData()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadData(with request: NSFetchRequest<ToDo> = ToDo.fetchRequest(), predicate: [NSPredicate]?) -> [ToDo] {
        
        if predicate != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicate!)
        }
        
        do {
            let item = try context.fetch(request)
            return item
        } catch {
            print("Error saving context \(error)")
        }
        
        return []
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) -> [Category] {
        do {
            let item = try context.fetch(request)
            return item
        } catch {
            print("Error saving context \(error)")
        }
        
        return []
    }


}
