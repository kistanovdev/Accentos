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
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTyped.delegate = self
        
    }
    
    @IBOutlet weak var wordTyped: UITextField!
    @IBOutlet weak var result: UILabel!
    
    
    //function that handles the processing of the word
    @IBAction func wordWasSumbitted(_ sender: Any) {
        let input = wordTyped.text!
        if isValid(input: input) && !input.isEmpty {
            let syllables = Syllabifyer(word:input).getSyllables()
            result.text = syllables.joined(separator: "-")
            wordTyped.resignFirstResponder()
            wordTyped.text?.removeAll()
        } else {
            shakeItem(item: wordTyped)
            wordTyped.resignFirstResponder()
            
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
    //function that handles the shake action
    func shakeItem(item: UITextField) {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = 3
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: wordTyped.center.x - 15, y: wordTyped.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: wordTyped.center.x + 15, y: wordTyped.center.y))
        item.layer.add(shakeAnimation, forKey: "position")
    }
}
extension Syllabify : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
