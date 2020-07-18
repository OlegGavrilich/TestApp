//
//  DrinksTableViewCell.swift
//  CocktailMenu
//
//  Created by Oleg Gavrilich on 7/16/20.
//  Copyright © 2020 Oleg Gavrilich. All rights reserved.
//

import UIKit

class DrinksTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkImg: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        drinkName.text = nil
        drinkImg.image = nil
    }

    func configure(drinkName: String) {
        self.drinkName.text = drinkName
    }
    
    func configure(drinkImg: UIImage?) {
        self.drinkImg.image = drinkImg
    }
}
