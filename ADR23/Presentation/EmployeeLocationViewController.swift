//
//  EmployeeLocationViewController.swift
//  ADR23
//
//  Created by Patrick Gaissert on 21.07.17.
//  Copyright © 2017 MaibornWolff GmbH. All rights reserved.
//

import UIKit
import MapKit

class EmployeeLocationViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!

    var employee: Employee?

    override func viewDidLoad() {
        super.viewDidLoad()

        addAnnotation()
    }

    private func addAnnotation() {
        let pin = MKPointAnnotation()
        if let coordinate = employee?.location?.coordinate {
            pin.coordinate = coordinate
        }
        pin.title = employee?.fullName

        mapView.showAnnotations([pin], animated: false)
        mapView.selectAnnotation(pin, animated: true)
    }

}
