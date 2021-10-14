//
//  Person.swift
//  Project10
//
//  Created by Hümeyra Şahin on 14.10.2021.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String){
        self.name = name
        self.image = image
    }
}
