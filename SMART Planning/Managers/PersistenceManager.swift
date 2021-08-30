//
//  Persistance.swift
//  JSONExercise
//
//  Created by Roman Kavinskyi on 6/24/21.
//

import CoreData

struct PersistenceManager {
    static let shared = PersistenceManager()

    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    func save() {
        guard viewContext.hasChanges else {
        print("😕😕😕 Saving context with no changes!!!!!!!!")
            return
        }
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
    
    func getAllTasks() -> [Exercise] {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()

        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("Error Fetching Users")
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        viewContext.delete(goal)
        save()
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

