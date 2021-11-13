//
//  Note.swift
//  Milestone 7
//
//  Created by Hümeyra Şahin on 4.11.2021.
//

import Foundation

class Note: Codable{
    
    var note: String
    var title: String
    
    init(title: String, note: String){
        self.title = title
        self.note = note
    }
    
}
