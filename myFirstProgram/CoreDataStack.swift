//
//  CoreDataStack.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 10/11/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "myFirstProgram")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public var _masterContext : NSManagedObjectContext?
    public var masterContext : NSManagedObjectContext? {
        get{
            if _masterContext == nil {
                let context = persistentContainer.newBackgroundContext()
                _masterContext = context
            }
            return _masterContext
        }
    }
    
    private var _mainContext : NSManagedObjectContext?
    public var mainContext : NSManagedObjectContext? {
        get{
            if _mainContext == nil {
                let context = persistentContainer.viewContext
                _mainContext = context
            }
            
            return _mainContext
        }
    }
    
    private var _saveContext : NSManagedObjectContext?
    public var saveContext : NSManagedObjectContext? {
        get{
            if _saveContext == nil {
                let context = persistentContainer.newBackgroundContext()
                _saveContext = context
            }
            return _saveContext
        }
    }
  
    
    public func performSave (context: NSManagedObjectContext) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                }
                catch {
                    print("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent)
                }
                
                }
        }
    }
}
