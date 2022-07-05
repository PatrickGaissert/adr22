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

    func divisions() async throws -> [Division] {
        let divisions = try persistenceAdapter.retrieveDivisions()

        if !divisions.isEmpty {
            return divisions
        } else {
            try await updateEmployees()
            return try persistenceAdapter.retrieveDivisions()
        }
    }

    func employees(for division: Division) throws -> [Employee] {
        return try persistenceAdapter.retrieveEmployees(for: division)
    }

    // MARK: - Private methods

    private func updateEmployees() async throws {
        let data = try await networkAdapter.retrieveEmployeeData()
        let employeeData = try JSONDecoder().decode([EmployeeData].self, from: data)
        await persistEmployeeData(employeeData)
    }

    private func persistEmployeeData(_ employeeData: [EmployeeData]) async {
        await withTaskGroup(of: Void.self) { taskGroup in
            employeeData.forEach { (employee) in
                taskGroup.addTask {
                    await persistEmployee(employee)
                }
            }
        }

        await persistenceAdapter.saveContext()
    }

    private func persistEmployee(_ employee: EmployeeData) async {
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

        await persistenceAdapter.createEmployee(firstName: employee.firstName, lastName: employee.lastName, location: location, photo: photo, divisionName: employee.division)
    }
}
