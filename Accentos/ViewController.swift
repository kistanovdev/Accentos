import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var wordTyped: UITextField!
    @IBAction func wordSubmitted(_ sender: Any) {
        let word = wordTyped.text!
        let dict = findDict(firstChar: word[(word.startIndex)])
        if dict[word] != nil {
            if word == dict[word] {
                result.text = "No accent here"
            } else {
                result.text = dict[word]
            }
        } else {
            result.text = "No such word"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

