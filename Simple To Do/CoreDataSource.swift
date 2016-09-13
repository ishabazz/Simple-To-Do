//
//  CoreDataSource.swift
//  Simple To Do
//
//  Created by Demo on 9/13/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import UIKit
import CoreData




class CoreDataSource:NSObject{
    
    let  npc:NSPersistentContainer
    
    var frcDelegate:NSFetchedResultsControllerDelegate?
    
    private var fetchedResultsController:NSFetchedResultsController<TaskObject>?
    
    private  var frc: NSFetchedResultsController<TaskObject>? {
        
        get {
            
            if  let  frc = fetchedResultsController {
                return frc
            }
            
            let fetchRequest:NSFetchRequest<TaskObject> = TaskObject.fetchRequest()
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
            
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: npc.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            frc.delegate = self.frcDelegate
            self.fetchedResultsController = frc
            return frc
        }
    }

    override init() {
       
        
        self.npc = NSPersistentContainer(name:"Model")
        
        npc.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
        }
        super.init()

    }
    
    
    /// setFRCDelegate
    /// sets a delegate for the Fetched Results Controller and performs a fetch
    ///
    /// - parameter delegate: the FRC delegate
    func setFRCDelegate(_ delegate:NSFetchedResultsControllerDelegate){
        
        self.frcDelegate = delegate
        
        self.fetchedResultsController = nil
        
        do{ try frc?.performFetch()}
        catch let error as
            NSError{
                print(error.localizedDescription)
        }
    }
    
    
    /// add: Adds a task to the list
    /// - Parameter task: The task that will be added
    /// - Returns: Void
    func add(task:String){
        
        let aTask = TaskObject(context: npc.viewContext)
        
        aTask.name = task
       
        aTask.completed  = false
        
        if let count = frc?.fetchedObjects?.count {
            aTask.order = Int16(count)
        }
        
        save()
    
        
    }
    
    
    /// taskForIndex: returns task info for an index
    /// - Parameter index: The indexPath of the task that will have it's completion state toggled
    /// - Returns: (String, Bool)
    
    func taskForIndex(index:IndexPath) -> (name:String?, completed:Bool?) {
        
        let task = frc?.object(at: index)
        return (name:task?.name , completed:task?.completed)
        
    }
    
    /// toggleCompletion: toggles the completeion state of a task at the given IndexPath
    /// - Parameter index: The indexPath of the task that will have it's completion state toggled
    /// - Returns: Void
    func toggleCompletion(index:IndexPath){
        
        let task = frc?.object(at: index)
       
        guard let completed = task?.completed else {return}
        
        task?.completed = !completed

        save()
    }
    
    
    /// taskCount: returns the number of tasks
    /// - Returns: Int
    func taskCount() -> Int {
        
    return frc?.fetchedObjects?.count ?? 0
        
    }
    
    /// delete: deletes the task at the specified index
    /// - Parameter index: The index of task that will be deleted
    /// - Returns: Void
    func delete(index:IndexPath){
        
        guard let task = frc?.object(at: index) else {return}
        
        npc.viewContext.delete(task)
        
        save()
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
    
    func save(){
        do{
            if npc.viewContext.hasChanges{
                try npc.viewContext.save()
            }
        }
        catch  let error {
            print(error.localizedDescription)
        }
    }
}



extension CoreDataSource:UITableViewDataSource{
    
    
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
        
        cell.taskLabel.attributedText =  format(text: task.name ?? "", strike: task.completed ?? false)
        
        cell.statusImageView?.image = task.completed ?? false ? UIImage(named: "Checked Box") : UIImage(named: "Check Box")
        
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
            
            
        default:
            break
        }
    }
    
    
}
