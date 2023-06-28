//
//  Employee.swift
//  ADR22
//
//  Created by Patrick Gaißert on 28.06.23.
//  Copyright © 2023 MaibornWolff GmbH. All rights reserved.
//
//

import Foundation
import SwiftData
import CoreLocation
import UIKit


@Model final public class Employee {
    var firstName: String
    var lastName: String
    @Attribute(.transformable)
    var location: CLLocation?
    @Attribute(.transformable)
    var photo: UIImage?
    var division: Division?

    init(firstName: String, lastName: String, location: CLLocation? = nil, photo: UIImage? = nil, division: Division? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.location = location
        self.photo = photo
        self.division = division
    }

}
