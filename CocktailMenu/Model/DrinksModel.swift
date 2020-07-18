//
//  DrinksModel.swift
//  CocktailMenu
//
//  Created by Oleg Gavrilich on 7/16/20.
//  Copyright © 2020 Oleg Gavrilich. All rights reserved.
//

import UIKit

// MARK: - Categories

struct Categories: Codable {
    let drinks: [Category]
}

struct Category: Codable {
    let strCategory: String
}

// MARK: - Drinks

struct Drinks: Codable {
    let drinks: [Drink]
}

struct Drink: Codable {
    let idDrink: String
    let strDrink: String
    let strDrinkThumb: String
}
