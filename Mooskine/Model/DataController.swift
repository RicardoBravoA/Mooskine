//
//  DataController.swift
//  Mooskine
//
//  Created by Ricardo Bravo on 29/06/21.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSAveViewContext()
            completion?()
        }
    }
}

extension DataController {
    func autoSAveViewContext(interval: TimeInterval = 30) {
        guard interval > 0 else {
            print("Cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSAveViewContext(interval: interval)
        }
    }
}
