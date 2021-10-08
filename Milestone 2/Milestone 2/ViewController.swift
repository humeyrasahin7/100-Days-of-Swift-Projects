//
//  ViewController.swift
//  Milestone 2
//
//  Created by Hümeyra Şahin on 8.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "My Shopping List"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
        navigationItem.rightBarButtonItems = [refresh, add]
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "items", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addTapped(){
        let indexPath = IndexPath(row: 0, section: 0)
        let ac = UIAlertController(title: "Adding Item", message: "Please write an item to add your shopping list", preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "add", style: .default){
            [weak self, weak ac] action in
            guard let item = ac?.textFields?[0].text else {return}
            self?.shoppingList.insert(item, at: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
            
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    @objc func refreshTapped(){
        
        shoppingList.removeAll()
        tableView.reloadData()
        
    }


}

