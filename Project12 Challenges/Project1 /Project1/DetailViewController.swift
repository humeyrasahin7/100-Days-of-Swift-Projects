//
//  DetailViewController.swift
//  Project1
//
//  Created by Hümeyra Şahin on 1.10.2021.
//

import UIKit

class DetailViewController: UIViewController{
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedImageIndex: Int?
    var totalImages: Int?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
            if let imageToLoad = selectedImage {
                imageView.image = UIImage(named: imageToLoad)
                if let total = totalImages{
                    if let indexToLoad = selectedImageIndex {
                        title = "Picture \(indexToLoad) of \(total)"
                        navigationItem.largeTitleDisplayMode = .never
                    }
                }
            }
        

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

  
}
