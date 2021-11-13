//
//  DetailsViewController.swift
//  Milestone 7
//
//  Created by Hümeyra Şahin on 4.11.2021.
//

import UIKit
import NotificationCenter

class DetailsViewController: UIViewController {


    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var note: UITextView!
    var textt: String!
        
    
    var items = [UIBarButtonItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        note.text = textt
        
        toolBar.isHidden = false
        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        items.append(trash)
        toolBar.setItems(items, animated: false)
       
        let notificationCenter = NotificationCenter()
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue //tells size pof keyboard
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            note.contentInset = .zero
        } else {
            note.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            
            
        }
        
        note.scrollIndicatorInsets = note.contentInset
        
        let selectedRange = note.selectedRange
        note.scrollRangeToVisible(selectedRange)
        
    }
    
    @objc func share(){
        
    }
    
    @objc func deleteNote(){
        note.text = ""
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController{
            
            //vc.notes.remove(at: 0)
            
            print(vc.notes.count)
            vc.tableView.reloadData()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
}
