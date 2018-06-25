//
//  Syllabify.swift
//  Accentos
//
//  Created by Daniil on 6/22/18.
//  Copyright © 2018 Daniil Kistanov. All rights reserved.
//
// View that takes a word and then splits it into syllables
// Uses special algorith developed by
// * Hernández-Figueroa, Z; Rodríguez-Rodríguez, G; Carreras-Riudavets, F (2009). *
// * Separador de sílabas del español - Silabeador TIP.                           *
// * Available at http://tip.dis.ulpgc.es

import Foundation
import UIKit

class Syllabify: UIViewController {
    
    @IBOutlet weak var wordTyped: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTyped.delegate = self
        
    }
    
    @IBAction func wordWasSumbitted(_ sender: Any) {
        let input = wordTyped.text!
        if isValid(input: input) && !input.isEmpty {
            let syllables = Syllabifyer(word:input).getSyllables()
            result.text = syllables.joined(separator: "-")
            wordTyped.resignFirstResponder()
            wordTyped.text?.removeAll()
        } else {
            let shakeAnimation = CABasicAnimation(keyPath: "position")
            shakeAnimation.duration = 0.07
            shakeAnimation.repeatCount = 4
            shakeAnimation.autoreverses = true
            shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: wordTyped.center.x - 15, y: wordTyped.center.y))
            shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: wordTyped.center.x + 15, y: wordTyped.center.y))
            wordTyped.layer.add(shakeAnimation, forKey: "position")
        }
    }
    func isValid(input:String) -> Bool {
        for letter in input {
            if !"abcdefghijklmnopqrstuvwxyzáéóíúü".contains(letter) {
                return false
            }
        }
        return true
    }
}
extension Syllabify : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
