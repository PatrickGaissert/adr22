//
//  Service.swift
//  ADR23
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
        return division.employees?.allObjects as? [Employee] ?? []
    }

    // MARK: - Private methods

    private func updateEmployees() async throws {
        let data = try await networkAdapter.retrieveEmployeeData()
        let employeeData = try JSONDecoder().decode([EmployeeData].self, from: data)
        persistEmployeeData(employeeData)
    }

    private func persistEmployeeData(_ employeeData: [EmployeeData]) {
        employeeData.forEach { (employee) in
            persistEmployee(employee)
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
