import UIKit
import Foundation

class AccentChecker: UIViewController {
        
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let path = Bundle.main.path(forResource: "data", ofType: "json")
            let url  = URL(fileURLWithPath: path!)
            let data = try Data(contentsOf: url)
            let dictionary = try JSONDecoder().decode([String:String].self, from: data)
        } catch {}
        tableView.showsVerticalScrollIndicator = true
        
    }
    
    
    
}

extension AccentChecker : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
 

