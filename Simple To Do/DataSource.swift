//
//  DataSource.swift
//  Simple To Do
//
//  Created by Demo on 7/16/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import Foundation
import UIKit


class DataSource:NSObject{
    
    
    ///   An array of tasks
    var tasks:[Task] = []
    
    /// User defaults
    let defaults = UserDefaults.standard

    
    /// add: Adds a task to the list
    /// - Parameter task: The task that will be added
    /// - Returns: Void
    func add(task:String){
        
        let aTask = Task(name: task, completed: false)
        tasks.append(aTask)
        
        save()
        
    }
    
    
    /// taskForIndex: returns task info for an index
    /// - Parameter index: The indexPath of the task that will have it's completion state toggled
    /// - Returns: (String, Bool)
    
    func taskForIndex(index:IndexPath) -> (name:String, completed:Bool) {
        
        let task = tasks[index.row]
        return (name:task.name , completed:task.completed)
        
    }
    
    /// toggleCompletion: toggles the completeion state of a task at the given IndexPath
    /// - Parameter index: The indexPath of the task that will have it's completion state toggled
    /// - Returns: Void
    func toggleCompletion(index:IndexPath){
        
        let task = tasks[index.row]
        task.completed = !task.completed
        tasks[index.row] = task
        save()
    }
    
    
    /// taskCount: returns the number of tasks
    /// - Returns: Int
    func taskCount() -> Int {
        
        return tasks.count
        
    }
    
    /// delete: deletes the task at the specified index
    /// - Parameter index: The index of task that will be deleted
    /// - Returns: Void
    func delete(index:IndexPath){
        
        tasks.remove(at:index.row)
        
    }
    
    
    // setupDefaultData: adds some default tasks to the list
    /// - Returns: Void
    func setupDefaultData(){
        
        add(task:"Eggs")
        add(task:"Milk")
        add(task:"Butter")
        add(task:"Sugar")
        add(task:"Apples")
        add(task:"Salad")
        
        defaults.set(true, forKey: Keys.initialized.rawValue) //Set the flag
        defaults.synchronize() //Save the changes immediately

        
    }
    
    
    func save(){
       let data =  NSKeyedArchiver.archivedData(withRootObject: tasks)
        guard  let filePath = FileController.filePath() else {
            return
        }
        do{
            try data.write(to: filePath)
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
    func loadFromFile(){
        guard  let filePath = FileController.filePath() else {return}
        
        guard let data =  NSData(contentsOf: filePath) else {return }

        guard  let list = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [Task] else {
            return
        }
        
        self.tasks = list
        
        
     }
}



extension DataSource:UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = taskCount()
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard   let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell else {return UITableViewCell()}
        
        let task = taskForIndex(index: indexPath)
        
        cell.taskLabel.attributedText =  format(text: task.name, strike: task.completed)
        
        cell.statusImageView?.image = task.completed ? UIImage(named: "Checked Box") : UIImage(named: "Check Box")
        
        return cell
        
    }
    
    func format(text:String, strike:Bool) -> NSAttributedString{
        
        
        if strike {
            return NSAttributedString(string: text, attributes: [NSStrikethroughStyleAttributeName:NSNumber(value:NSUnderlineStyle.styleSingle.rawValue)])
        }
        return  NSAttributedString(string: text, attributes: [NSStrikethroughStyleAttributeName:NSNumber(value:NSUnderlineStyle.styleNone.rawValue)])
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            delete(index: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        default:
            break
        }
    }
    
    
}
