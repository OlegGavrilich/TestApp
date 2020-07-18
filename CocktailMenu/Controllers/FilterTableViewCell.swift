//
//  FilterOptionCell.swift
//  CocktailMenu
//
//  Created by Oleg Gavrilich on 18.07.2020.
//  Copyright © 2020 Oleg Gavrilich. All rights reserved.
//

import UIKit

class FilterOptionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    func configure(with title: String, selected: Bool, searchText: String = "") {
        titleLabel.text = title
        accessoryType = selected ? .checkmark : .none
    }
}
