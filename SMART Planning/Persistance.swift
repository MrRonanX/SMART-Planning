//
//  Persistance.swift
//  JSONExercise
//
//  Created by Roman Kavinskyi on 6/24/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    func save() {
        guard viewContext.hasChanges else { fatalError("Fatal Error Saving Data") }
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
            viewContext.rollback()
            fatalError("Error saving data")
        }
    }
    
    func getAllGoals() -> [Goal] {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()

        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("Error Fetching Users")
        }
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Goal")
        //container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

