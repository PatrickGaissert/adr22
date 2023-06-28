//
//  PersistenceAdapter.swift
//  ADR23
//
//  Created by Patrick Gaissert on 27.07.17.
//  Copyright © 2017 MaibornWolff GmbH. All rights reserved.
//

import UIKit
import CoreLocation
import os
import SwiftData

/// Database Access Adapter
class PersistenceAdapter {
    private lazy var context: ModelContext = {
        return ModelContext(modelContainer)
    }()

    // MARK: - Create

    func createEmployee(firstName: String, lastName: String, location: CLLocation?, photo: UIImage?, divisionName: String) {
        let division = Division(name: divisionName)
        context.insert(division)

        let employee = Employee(firstName: firstName, lastName: lastName, location: location, photo: photo, division: division)
        context.insert(employee)
    }

    // MARK: - Retrieve

    func retrieveDivisions() throws -> [Division] {
        os_log("Retrieving divisions via persistence.")

        let request = FetchDescriptor<Division>()
        return try context.fetch(request)
    }

    // MARK: - Private methods

    private func retrieveDivision(name: String) -> Division? {
        do {
            // Constrain to name
            let predicate = #Predicate<Division> { division in
                division.name == name
            }
            var request = FetchDescriptor<Division>(predicate: predicate)
            request.fetchLimit = 1

            return try context.fetch(request).first
        } catch {
            os_log("%@", String(describing: error))
            return nil
        }
    }

    // MARK: - SwiftData stack

    private lazy var modelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: [Division.self, Employee.self])
        } catch {
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
        }
    }()

    // MARK: - SwiftData Saving support

    func saveContext() {
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
