//
//  MenuTableViewController.swift
//  CocktailMenu
//
//  Created by Oleg Gavrilich on 7/16/20.
//  Copyright © 2020 Oleg Gavrilich. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var drinkService: DrinksServiceProtocol = DrinksDBService()
    
    var drinksSectionData = [DrinkListSection]()
    var drinksData = [String: [Drink]]()
    
    var categories = [String]()
    var selectedCategories: Set<String> = ["Ordinary_Drink", "Cocktail"]

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        loadCategories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FilterSelectionViewController {
            destination.options = categories
            destination.selectedOptions = selectedCategories
            destination.delegate = self
        }
    }
    
    // MARK: - Methods
    
    func loadCategories() {
        drinkService.getCategories { (categories, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let categories = categories {
                self.categories = categories
                self.selectedCategories = Set(categories)
                self.reloadDrinksData()
            }
        }
    }
        
    func reloadDrinksData() {
        self.drinksData.removeAll()
        let group = DispatchGroup()
        
        for category in selectedCategories {
            group.enter()
            loadDrinks(for: category) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.drinksSectionData = self.drinksData.map { (key, value) -> DrinkListSection in
                return DrinkListSection(title: key, items: value)
            }
            self.tableView.reloadData()
        }
    }
    
    func loadDrinks(for category: String, successCompletion: @escaping () -> Void) {
        drinkService.getDrinks(category: category) { (drinks, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let drinks = drinks {
                self.drinksData[category] = drinks
            }
            successCompletion()
        }
    }
    
    func loadImage(for indexPath: IndexPath) {
        let drink = drinksSectionData[indexPath.section].items[indexPath.row]
        drinkService.getImage(for: drink.strDrinkThumb) { (image, error) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                let cell = self.tableView.cellForRow(at: indexPath) as? DrinksTableViewCell
                cell?.configure(drinkImg: image)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MenuTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return drinksSectionData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinksSectionData[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cocktailCell") as! DrinksTableViewCell
        let drink = drinksSectionData[indexPath.section].items[indexPath.row]
        cell.configure(drinkName: drink.strDrink)
        loadImage(for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drinksSectionData[section].title
    }
}

// MARK: - FilterSelectionControllerDelegate

extension MenuTableViewController: FilterSelectionControllerDelegate {
    
    func didSelectFilter(_ filters: Set<String>) {
        selectedCategories = filters
        reloadDrinksData()
    }
}
