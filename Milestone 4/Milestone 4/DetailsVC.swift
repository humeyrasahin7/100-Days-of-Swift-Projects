//
//  DetailsVC.swift
//  Milestone 4
//
//  Created by Hümeyra Şahin on 19.10.2021.
//

import UIKit

class DetailsVC: UIViewController {
    @IBOutlet var image: UIImageView!
    var selectedImage: Images?
    var selectedImageName: String?
    var path: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedImage != nil {
            image.image = UIImage(contentsOfFile: path!.path)
            if let name = selectedImageName{
                title = name
            }
        }
        
    }

}
