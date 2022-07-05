//
//  DepartmentsViewController.swift
//  ADR22
//
//  Created by Patrick Gaissert on 21.07.17.
//  Copyright © 2017 MaibornWolff GmbH. All rights reserved.
//

import UIKit

class DepartmentsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private let service = Service()
    private var divisions: [Division]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Bereiche"

        loadDivisions()
    }

    private func loadDivisions() {
        activityIndicator.startAnimating()
        service.divisions(completion: { (divisions) in
            self.activityIndicator.stopAnimating()
            self.divisions = divisions
            self.tableView.reloadData()
        })
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let division = divisions?[indexPath.row] else {
            return
        }

        let employees = service.employees(for: division)
        (segue.destination as! EmployeesViewController).employees = employees
    }

}

extension DepartmentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return divisions?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Division", for: indexPath)
        let division = divisions?[indexPath.row]
        cell.textLabel?.text = division?.name
        return cell
    }

}
