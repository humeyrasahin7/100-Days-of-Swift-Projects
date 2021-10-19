//
//  ViewController.swift
//  Project12Test
//
//  Created by Hümeyra Şahin on 17.10.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        defaults.set(23, forKey: "age")
        
    }


}

