//
//  Division.swift
//  ADR22
//
//  Created by Patrick Gaißert on 28.06.23.
//  Copyright © 2023 MaibornWolff GmbH. All rights reserved.
//
//

import Foundation
import SwiftData


@Model final public class Division {
    @Attribute(.unique)
    var name: String
    @Relationship(inverse: \Employee.division)
    var employees: [Employee] = []

    init(name: String) {
        self.name = name
        self.employees = employees
    }

}
