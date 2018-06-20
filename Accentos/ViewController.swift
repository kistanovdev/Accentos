import UIKit
import Foundation

class ViewController: UIViewController {
    
    //the three fields that are responsible
    //find the word
    //find the json file matching the first letter
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var wordTyped: UITextField!
    
    @IBAction func wordSubmitted(_ sender: Any) {
        let word = wordTyped.text!
        let dict = findDict(firstChar: word[(word.startIndex)])
        if dict[word] != nil && !dict.isEmpty {
            if word == dict[word] {
                result.text = "No accent here"
            } else {
                result.text = dict[word]
            }
        } else {
            result.text = "No such word"
        }
        //dismiss the keyboard once pressed submit
        wordTyped.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTyped.delegate = self
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
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
 

