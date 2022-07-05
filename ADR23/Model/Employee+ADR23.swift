//
//  Employee+ADR23.swift
//  ADR23
//
//  Created by Patrick Gaissert on 27.07.17.
//  Copyright © 2017 MaibornWolff GmbH. All rights reserved.
//

import Foundation

extension Employee {
    /// Full name formatted according to the current locale.
    var fullName: String {
        var nameComponents = PersonNameComponents()
        nameComponents.givenName = firstName
        nameComponents.familyName = lastName

        let formatter = PersonNameComponentsFormatter()
        return formatter.string(from: nameComponents)
    }

}
