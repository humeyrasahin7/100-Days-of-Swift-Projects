//
//  ViewController.swift
//  Milestone 7
//
//  Created by Hümeyra Şahin on 4.11.2021.
//

import UIKit

class ViewController: UITableViewController {

    var notes = [Note]()
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NOTES"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let note = Note(title: "deneme", note: "deneme title")
        notes.append(note)
        print(notes.count)
        
    }
    
    

    

    
    @objc func addNote(){
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
            navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(vc.share)), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveNewText))]
            
            
        }
        
   }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
            index = indexPath.row
            let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(vc.deleteNote))
            vc.title = notes[indexPath.row].title
            vc.textt = notes[indexPath.row].note
            //vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(vc.share))
            vc.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(vc.share)), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveNewText))]                               
            var items = vc.items
            
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            items.append(trash)
            //toolbarItems = items
            vc.toolbarItems = items
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func saveNewText(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
            let note = Note(title: "", note: ".")
        notes.append(note)
        tableView.reloadData()
            
        }
    }
    
    
}

