//
//  Images.swift
//  Milestone 4
//
//  Created by Hümeyra Şahin on 18.10.2021.
//

import UIKit

class Images: NSObject, Codable {
    
    var caption: String
    var image: String
    
    init(caption: String, image: String) {
        self.image = image
        self.caption = caption
    }

}

