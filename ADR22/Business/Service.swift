//
//  Service.swift
//  ADR22
//
//  Created by Patrick Gaissert on 27.07.17.
//  Copyright © 2017 MaibornWolff GmbH. All rights reserved.
//

import UIKit
import CoreLocation

/// Business Logic Component
struct Service {
    private let networkAdapter = NetworkAdapter()
    private let persistenceAdapter = PersistenceAdapter()

    func divisions(completion: @escaping ([Division]?) -> Void) {
        guard let divisions = persistenceAdapter.retrieveDivisions() else {
            // Handle persistence error
            completion(nil)
            return
        }

        if !divisions.isEmpty {
            completion(divisions)
        } else {
            updateEmployees {
                completion(self.persistenceAdapter.retrieveDivisions())
            }
        }
    }

    func employees(for division: Division) -> [Employee]? {
        return persistenceAdapter.retrieveEmployees(for: division)
    }

    // MARK: - Private methods

    private func updateEmployees(completion: @escaping () -> Void) {
        networkAdapter.retrieveEmployeeData(completionHandler: { (data, _) in
            guard let data = data,
                  let employeeData = try? JSONDecoder().decode([EmployeeData].self, from: data) else {
                DispatchQueue.main.async(execute: { completion() })
                return
            }

            self.persistEmployeeData(employeeData)

            DispatchQueue.main.async(execute: { completion() })
        })
    }

    private func persistEmployeeData(_ employeeData: [EmployeeData]) {
        employeeData.forEach { (employee) in
            self.persistEmployee(employee)
        }

        persistenceAdapter.saveContext()
    }

    private func persistEmployee(_ employee: EmployeeData) {
        var location: CLLocation?
        let locationComponents = employee.location.components(separatedBy: ",")

        if locationComponents.count == 2,
           let latitude = CLLocationDegrees(locationComponents[0]),
           let longitude = CLLocationDegrees(locationComponents[1]) {
            location = CLLocation(latitude: latitude, longitude: longitude)
        }

        var photo: UIImage?
        if let photoData = Data(base64Encoded: employee.photo) {
            photo = UIImage(data: photoData)
        }

        persistenceAdapter.createEmployee(firstName: employee.firstName, lastName: employee.lastName, location: location, photo: photo, divisionName: employee.division)
    }

}
