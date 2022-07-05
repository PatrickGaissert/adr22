//
//  EmployeeData.swift
//  ADR23
//
//  Created by Patrick Gaissert on 27.07.17.
//  Copyright © 2017 MaibornWolff GmbH. All rights reserved.
//

import Foundation

/// Employee JSON Data Transfer Object
struct EmployeeData: Codable {
    let firstName: String
    let lastName: String
    let division: String
    let location: String
    let photo: String

}
