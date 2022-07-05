//
//  DepartmentsViewController.swift
//  ADR23
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

        Task {
            await loadDivisions()
        }
    }

    private func loadDivisions() async {
        activityIndicator.startAnimating()
        defer {
            activityIndicator.stopAnimating()
        }

        do {
            divisions = try await service.divisions()
            tableView.reloadData()
        } catch {
            let alert = UIAlertController(title: "Fehler", message: "Abrufen der Bereiche ist fehlgeschlagen. Bitte versuchen sie es später erneut", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let division = divisions?[indexPath.row] else {
            return
        }

        let employees = try? service.employees(for: division)
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
