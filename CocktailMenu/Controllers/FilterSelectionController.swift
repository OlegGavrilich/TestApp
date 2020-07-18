//
//  FilterSelectionController.swift
//  CocktailMenu
//
//  Created by Oleg Gavrilich on 18.07.2020.
//  Copyright © 2020 Oleg Gavrilich. All rights reserved.
//

import UIKit

protocol FilterSelectionControllerDelegate: class {
    func didSelectFilter(_ filters: Set<String>)
}

class FilterSelectionViewController: UIViewController {
    
    var selectedOptions = Set<String>()
    var options = [String]()
    
    weak var delegate: FilterSelectionControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        delegate?.didSelectFilter(selectedOptions)
    }
}

// MARK: - UITableViewDataSource

extension FilterSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterOptionCell
        let selected = selectedOptions.contains(options[indexPath.row])
        cell.configure(with: options[indexPath.row].description, selected: selected)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FilterSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let index = selectedOptions.firstIndex(of: options[indexPath.row]) {
            selectedOptions.remove(at: index)
        } else {
            selectedOptions.insert(options[indexPath.row])
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
