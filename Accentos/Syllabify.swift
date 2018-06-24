//
//  Syllabify.swift
//  Accentos
//
//  Created by Daniil on 6/22/18.
//  Copyright © 2018 Daniil Kistanov. All rights reserved.
//
//View that takes a word and then splits it into syllables
//Uses special algorith developed by
//* Hernández-Figueroa, Z; Rodríguez-Rodríguez, G; Carreras-Riudavets, F (2009). *
//* Separador de sílabas del español - Silabeador TIP.                           *
//* Available at http://tip.dis.ulpgc.es

import Foundation
import UIKit

class Syllabify: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var wordTyped: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
    @IBAction func wordWasSumbitted(_ sender: Any) {
        let syllables = Syllabifyer(word:wordTyped.text!).getSyllables()
        result.text = syllables.joined(separator: "-")
    }
}
