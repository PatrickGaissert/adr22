//
//  EmployeesViewController.swift
//  ADR22
//
//  Created by Patrick Gaissert on 21.07.17.
//  Copyright © 2017 MaibornWolff GmbH. All rights reserved.
//

import UIKit

class EmployeesViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!

    private let service = Service()
    var employees: [Employee]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Mitarbeiter"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UICollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell),
            let employee = employees?[indexPath.row] else {
            return
        }

        (segue.destination as! EmployeeLocationViewController).employee = employee
    }

}

extension EmployeesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return employees?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Employee", for: indexPath) as! EmployeeCollectionViewCell
        let employee = employees?[indexPath.row]
        cell.imageView.image = employee?.photo
        return cell
    }

}
