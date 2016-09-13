//
//  ViewController.swift
//  Simple To Do
//
//  Created by Demo on 7/16/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let data = CoreDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = data
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        data.setFRCDelegate(self)
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addPressed(_ sender: AnyObject) {
        
        var textField:UITextField?
        
        let alert = UIAlertController(title: "New Task", message: "Enter task name", preferredStyle: .alert)
       
        alert.addTextField { (field) in
            textField = field
            
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let name = textField?.text else {return}
            self.data.add(task: name)
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(addAction)
        
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)

    }

}


extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data.toggleCompletion(index: indexPath)
        
    }
    
}


extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
        
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard  let indexPath = newIndexPath else {
                return
            }
            
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
        case .delete:
            guard  let indexPath = indexPath else {
                return
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard  let fromIndexPath = indexPath, let toIndexPath = newIndexPath else {
                return
            }
            self.tableView.moveRow(at: fromIndexPath, to: toIndexPath)
            
        case .update:
            guard  let indexPath = newIndexPath else {
                return
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
            
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
        
    }
}




