import UIKit
import Foundation

class AccentChecker: UIViewController {
        
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Word] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        do {
            let path = Bundle.main.path(forResource: "data", ofType: "json")
            let url  = URL(fileURLWithPath: path!)
            let data = try Data(contentsOf: url)
            let accented_words = try JSONDecoder().decode([String:String].self, from: data)
            items = createArray(dict: accented_words)
        } catch {}
        
    }
    
    func createArray(dict: [String:String]) -> [Word] {
        
        var words: [Word] = []
        
        for item in dict {
            print(item.value)
            words.append(Word(clear_version: item.key, result: item.value))
        }
        
        return words
    }
    
    
    
}

extension AccentChecker : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AccentChecker: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell") as! TableViewCell
        cell.setCell(item: item)
        return cell
    }
}
 

