//
//  FirebaseDataSource.swift
//  Simple-To-Do
//
//  Created by Demo on 11/19/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FBKey{
    static let name = "name"
    static let completed = "completed"
}
class FirebaseDataSource{
    
    let ref  = FIRDatabase.database().reference().child("tasks")
    
    ///   An array of tasks
    var tasks:[FIRDataSnapshot] = []
    
    /// add: Adds a task to the list
    /// - Parameter task: The task that will be added
    /// - Returns: Void
    func add(task:String){
        
        let newTask = ref.childByAutoId()
        newTask.setValue([FBKey.name:task])
        newTask.setValue([FBKey.completed:false])

        
    }
    
    
    /// taskForIndex: returns task info for an index
    /// - Parameter index: The indexPath of the task that will have it's completion state toggled
    /// - Returns: (String, Bool)
    
    func taskForIndex(index:IndexPath) -> (name:String, completed:Bool)? {
        
        let task = tasks[index.row]
        
        guard let dict = task.value as? NSDictionary else {
            return nil
        }
        guard let name = dict.value(forKey: FBKey.name) as? String else {
            return nil
        }
        guard let completed = dict.value(forKey: FBKey.completed) as? Bool else {
            return nil
        }
        
        return (name:name , completed:completed)
        
    }
    
    /// toggleCompletion: toggles the completeion state of a task at the given IndexPath
    /// - Parameter index: The indexPath of the task that will have it's completion state toggled
    /// - Returns: Void
    func toggleCompletion(index:IndexPath){
        
        
        let task = tasks[index.row]
        
        guard let dict = task.value as? NSDictionary else {
            return
        }
   
        guard let completed = dict.value(forKey: FBKey.completed) as? Bool else {
            return
        }
        let newState = !completed
       
        ref.child(task.key).setValue([FBKey.completed:newState])
  
        
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
        
        let task = tasks[index.row]
        
         ref.child(task.key).setValue(nil)
        
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
        
    }

}
