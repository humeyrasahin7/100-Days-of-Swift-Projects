//
//  WikiView.swift
//  Project16
//
//  Created by Hümeyra Şahin on 27.10.2021.
//

import UIKit
import WebKit

class WikiView: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var urlToShow: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard urlToShow != nil else {
            print("Website not set")
            navigationController?.popViewController(animated: true)
            return
        }
        
        if let url = URL(string: urlToShow) {
            webView.load(URLRequest(url: url))
        }
    }
   
    
    
}
