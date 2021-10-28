//
//  ViewController.swift
//  Project18
//
//  Created by Hümeyra Şahin on 28.10.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //print("im inside viewdidload")
        //assert(1 == 2, "math failure")
        //assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing!")
        //assertion crashes only happen while debugging, xcode automatically disables in release version.
        
        for i in 0...100{
            print("number is \(i).")
        }
        
    }


}

