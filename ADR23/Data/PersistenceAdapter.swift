//
//  PersistenceAdapter.swift
//  ADR23
//
//  Created by Patrick Gaissert on 27.07.17.
//  Copyright © 2017 MaibornWolff GmbH. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import os

/// Database Access Adapter
class PersistenceAdapter {
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Create

    func createEmployee(firstName: String, lastName: String, location: CLLocation?, photo: UIImage?, divisionName: String) {
        let employee = Employee(context: context)
        employee.firstName = firstName
        employee.lastName = lastName
        employee.location = location
        employee.photo = photo

        let division: Division

        if let existingDivision = retrieveDivision(name: divisionName) {
            division = existingDivision
        } else {
            // New division
            division = Division(context: context)
            division.name = divisionName
        }
        employee.division = division
    }

    // MARK: - Retrieve

    func retrieveDivisions() throws -> [Division] {
        os_log("Retrieving divisions via persistence.")

        let request: NSFetchRequest<Division> = Division.fetchRequest()
        let divisions = try context.fetch(request)
        return divisions
    }

    // MARK: - Private methods

    private func retrieveDivision(name: String) -> Division? {
        do {
            let request: NSFetchRequest<Division> = Division.fetchRequest()

            // Constrain to name
            request.predicate = NSPredicate(format: "name == %@", name)
            let divisions = try context.fetch(request)
            return divisions.first
        } catch {
            os_log("%@", String(describing: error))
            return nil
        }
    }

    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ADR23")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
