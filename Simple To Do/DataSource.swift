//
//  DataSource.swift
//  Simple To Do
//
//  Created by Demo on 7/16/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import Foundation



class DataSource:NSObject{
    
  private var tasks:[Task] = []
    
    /// add: Adds a new task
    /// - Parameter task: String
    /// - Returns: Void
    func add(task:String){
        
        let aTask = Task(name: task, completed: false)
        
        tasks.append(aTask)
        
    }
    
    
    func taskForIndex(index:IndexPath) -> (name:String, completed:Bool) {
        
        let task = tasks[index.row]
        return (name:task.name , completed:task.completed)
        
    }
    
    func toggleCompletion(index:IndexPath){
        
        var task = tasks[index.row]
        task.completed = !task.completed
        tasks[index.row] = task
        
    }

    func taskCount() -> Int {
        
        return tasks.count
        
    }
    func delete(index:IndexPath){
        
        tasks.remove(at:index.row)
        
    }

}
