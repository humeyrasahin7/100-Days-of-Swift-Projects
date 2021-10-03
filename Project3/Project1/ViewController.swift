//
//  ViewController.swift
//  Project1
//
//  Created by Hümeyra Şahin on 1.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer^^"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                //this is a picture to load
                
                pictures.append(item)
                
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
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            vc.totalImages = pictures.count
            vc.selectedImageIndex = (indexPath.row + 1)
            
        }
    }
    
    @objc func shareTapped(){
        
        let recommandation = "Hey! I recommand you this App!"
        let string1 = "https://apps.apple.com/tr/app/keynote/id409183694?l=tr&mt=12"
        let url = URL(string: string1)
        
    
        
        let vc = UIActivityViewController (activityItems: [recommandation,url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

