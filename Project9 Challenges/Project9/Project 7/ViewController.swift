//
//  ViewController.swift
//  Project 7
//
//  Created by Hümeyra Şahin on 9.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var keyWord: String?
    var filteredPetitions = [Petition]()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        let credits = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showCredit))
        let filter = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFiltered))
        navigationItem.rightBarButtonItems = [credits, filter]
    }
    
   @objc func fetchJSON(){
        
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
    
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
           
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                parse(json: data)
                    return
                }
            }
       performSelector(onMainThread: #selector(showAllert), with: nil, waitUntilDone: false)
        
    }
    
    @objc func showCredit(){
        let ac = UIAlertController(title: "Credits:", message: "Data comes from 'We The People' API of the White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    @objc func showFiltered(){
        let ac = UIAlertController(title: "Filtering Results", message: "Please enter a keyword to filter results", preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Filter", style: .default){
            [weak self, weak ac] action in
            guard let keyWord = ac?.textFields?[0].text else {return}
            self?.filterResult(keyWord)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    func filterResult(_ keyWord: String){
        
        let keyWord = keyWord.lowercased()
      
        DispatchQueue.global().async { [weak self] in
            for petition in self!.petitions {
                if petition.body.contains(keyWord){
                    self?.count = 1
                    self?.filteredPetitions.append(petition)
                }
            }
                    if self!.count == 0 {
                    let ac = UIAlertController(title: "NOT FOUND", message: "the key word is not fo", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                    DispatchQueue.main.async { [self] in
                        self!.present(ac, animated: true)
                    }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            
            self!.tableView.reloadData()
        }
        
        
    }
    
    @objc func showAllert(){
        
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        
    
    
    func parse(json: Data){
        
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            
        } else {
            performSelector(onMainThread: #selector(showAllert), with: nil, waitUntilDone: false)
        }
            
        }
                    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch count{
        case 0:
            return petitions.count
        case 1:
            return filteredPetitions.count
        default:
            return petitions.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch count{
        case 0:
            let petition = petitions[indexPath.row]
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
            return cell
            
        case 1:
            let petition = filteredPetitions[indexPath.row]
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
            return cell
        default:
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

