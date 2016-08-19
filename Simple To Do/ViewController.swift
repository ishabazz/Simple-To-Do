//
//  ViewController.swift
//  Simple To Do
//
//  Created by Demo on 7/16/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import UIKit

enum Keys:String{
    case initialized
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let data = DataSource()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = data
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if !defaults.bool(forKey: Keys.initialized.rawValue){
            data.setupDefaultData()
        }
        
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
        self.tableView.reloadData()
        
    }
    

 
    
    
}

