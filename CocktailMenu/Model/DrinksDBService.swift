//
//  DrinksDBService.swift
//  CocktailMenu
//
//  Created by Oleg Gavrilich on 7/16/20.
//  Copyright © 2020 Oleg Gavrilich. All rights reserved.
//

import UIKit

class DrinksDBService: DrinksServiceProtocol {
   
    let drinkCache = NSCache<AnyObject, AnyObject>()
    
    func getDrinks(category: String, completion: @escaping ([Drink]?, Error?) -> Void) {
        let category = category.replacingOccurrences(of: " ", with: "_")
        let drinksStringUrl = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(category)"
        
        guard let drinksUrl = URL(string: drinksStringUrl) else {
            completion(nil, nil)
            return
        }
        
        let request = URLRequest(url: drinksUrl)


        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let drinksData = try JSONDecoder().decode(Drinks.self, from: data)
                completion(drinksData.drinks, nil)
            } catch {
                completion(nil, error)
            }            
        }.resume()
    }
    
    func getCategories(completion: @escaping ([String]?, Error?) -> Void) {
        let categoryStringUrl = "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list"
        
        guard let categoryUrl = URL(string: categoryStringUrl) else { return }
        
        let request = URLRequest(url: categoryUrl)

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else { return }
            
            do {
                let categories = try JSONDecoder().decode(Categories.self, from: data)
                let stringCategories = categories.drinks.map { (category) -> String in
                    return category.strCategory
                }
                completion(stringCategories, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func getImage(for drink: String, completion: @escaping (UIImage?, Error?) -> Void) {
        
        guard let imageUrl = URL(string: drink) else { return }
        let request = URLRequest(url: imageUrl)
        if let image = drinkCache.object(forKey: imageUrl as AnyObject) {
            completion(image as? UIImage , nil)
        } else {
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                
                completion(UIImage(data: data), nil)
                self.drinkCache.setObject(UIImage(data: data)!, forKey: imageUrl as AnyObject)
            }.resume()
        }
    }
}

