//
//  ViewController.swift
//  Project1
//
//  Created by Hümeyra Şahin on 1.10.2021.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()
    

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
                
            }
        }
        pictures.sort()
        print(pictures)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {fatalError("error")}
        cell.image.image = UIImage(named: pictures[indexPath.item])
        cell.name.text = pictures[indexPath.item]
        cell.image.layer.borderWidth = 2
        cell.image.layer.borderColor = UIColor.lightGray.cgColor
        cell.image.layer.cornerRadius = 2
        cell.layer.cornerRadius = 3
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 3
        return cell

    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            vc.totalImages = pictures.count
            vc.selectedImageIndex = (indexPath.row + 1)
        }
    }
}

