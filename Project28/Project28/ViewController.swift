//
//  ViewController.swift
//  Project28
//
//  Created by Hümeyra Şahin on 19.11.2021.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    var barButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Nothing to see"
        barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        navigationItem.rightBarButtonItem = nil
        
        let notificatinCenter = NotificationCenter.default
        notificatinCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificatinCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificatinCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "identify your self"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self ] success, authenticaitonError in
                DispatchQueue.main.sync {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        //error
                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified, please try again later", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "ok", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
                
            }
        } else {
            // no biometry authentication possible
            let ac = UIAlertController(title: "biometry unavailable", message: "your device is not configered for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
            
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification{
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            
        }
        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage(){
        secret.isHidden = false
        navigationItem.rightBarButtonItem = barButtonItem
        title = "secret stuff"
        
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
    }
    
    @objc func saveSecretMessage(){
        guard secret.isHidden == false else {return}
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        navigationItem.rightBarButtonItem = nil
        title = "nothing to see here"
    }
    
   
    
}

