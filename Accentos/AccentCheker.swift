import UIKit
import Foundation

class AccentChecker: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTyped.delegate = self
    }
    
    @IBAction func closeView(_ sender: Any) {
        wordTyped.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    //the three fields that are responsible
    //find the word
    //find the json file matching the first letter
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var wordTyped: UITextField!
    
    @IBAction func wordSubmitted(_ sender: Any) {
        //take input
        let word = wordTyped.text!.lowercased()
        if !word.isEmpty && isValidString(input:word) {//validate
            //generate the duct
            let dict = findDict(firstChar: word[(word.startIndex)])
            if dict[word] != nil {//if key exists
                if word == dict[word] {result.text = "No accent here"}
                else {result.text = dict[word]}
            } else {
                result.text = "No such word"
            }
            //dismiss the keyboard once pressed submit
            wordTyped.resignFirstResponder()
        } else {
            //dismiss the keyboard is the input is empty
            result.text = "Invalid input"
            wordTyped.resignFirstResponder()
        }
        wordTyped.text = ""
    }
    
    //function that build a dictionary out of a json file
    //I prepared 26 json with 160000 spanish words
    //based on that letter it returns
    func findDict(firstChar:Character) -> [String:String] {
        do {
            let path = Bundle.main.path(forResource: String(firstChar), ofType: "json")
            let url  = URL(fileURLWithPath: path!)
            let data = try Data(contentsOf: url)
            let words = try JSONDecoder().decode([String:String].self, from: data)
            return words
        }
        catch {
            return [:]
        }
    }
    //funcation that makes sure all input is valid
    func isValidString(input:String) -> Bool {
        let alphabet = "abcdefghijklmnopqrstuvwxyzñ"
        for letter in input {
            if !alphabet.contains(letter) {return false}
        }
        return true
    }
}

extension AccentChecker : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
 

