//
//  ViewController.swift
//  Project1
//
//  Created by Hümeyra Şahin on 1.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var counts = [Int]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer^^"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                //this is a picture to load
                
                pictures.append(item)
                let count = userDefaults.object(forKey: "counts") as? [Int] ?? [Int]()
                self.counts = count
                
                
            }
        }
        pictures.sort()
        print(pictures)
        
       
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        if counts.isEmpty{
            cell.detailTextLabel?.text = "viewed 0 times"
            counts[indexPath.row] = 0
        } else {
        cell.detailTextLabel?.text = "Viewed \(counts[indexPath.row]) times"
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            vc.totalImages = pictures.count
            vc.selectedImageIndex = (indexPath.row + 1)
            counts[indexPath.row] += 1
            userDefaults.set(counts, forKey: "counts")
            tableView.reloadData()
        }
    }
}

