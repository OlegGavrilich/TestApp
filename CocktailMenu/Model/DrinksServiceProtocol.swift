//
//  DrinksServiceProtocol.swift
//  CocktailMenu
//
//  Created by Oleg Gavrilich on 7/16/20.
//  Copyright © 2020 Oleg Gavrilich. All rights reserved.
//

import UIKit

protocol DrinksServiceProtocol {
    func getDrinks(category: String, completion: @escaping ([Drink]?, Error?) -> Void)
    func getImage(for drink: String, completion: @escaping (UIImage?, Error?) -> Void)
    func getCategories(completion: @escaping ([String]?, Error?) -> Void)
}
