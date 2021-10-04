//
//  DetailsViewController.swift
//  Milestone 1
//
//  Created by Hümeyra Şahin on 4.10.2021.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var imagetoShow: UIImageView!
    var imagetoLoad: String?
    var countryName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        if let imagetoLoad = imagetoLoad {
            imagetoShow.image = UIImage(named: imagetoLoad)
            title = imagetoLoad
            imagetoShow.layer.borderWidth = 1.0
            imagetoShow.layer.borderColor = UIColor.darkGray.cgColor
            navigationItem.largeTitleDisplayMode = .never
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        }
    }
    @objc func shareTapped(){
        guard let img = imagetoShow.image?.jpegData(compressionQuality: 0.8)
            else{
                print("no image found!!")
                return
            }
        
        let ac = UIActivityViewController(activityItems: [img], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    


}
