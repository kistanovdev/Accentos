//
//  TableViewCell.swift
//  Accentos
//
//  Created by Daniil on 7/5/18.
//  Copyright © 2018 Daniil Kistanov. All rights reserved.
//


import UIKit
import Foundation


class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var word: UILabel!
    
    func setCell(item: Word) {
        word.text = item.result
    }
    
}
