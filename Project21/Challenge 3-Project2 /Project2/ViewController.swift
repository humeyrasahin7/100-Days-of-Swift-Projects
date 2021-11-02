//
//  ViewController.swift
//  Project2
//
//  Created by Hümeyra Şahin on 2.10.2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var counter = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        registerLocal()
        scheduleLocal()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
        countries+=["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        /*
        countries.append("estonia")
        countries.append("france")
        countries.append("germany")
        countries.append("ireland")
        countries.append("italy")
        countries.append("monaco")
        countries.append("nigeria")
        countries.append("poland")
        countries.append("russia")
        countries.append("spain")
        countries.append("uk")
        countries.append("us")
         */
        
        askQuestion(action: nil)
        button1.layer.borderWidth = 3
        button2.layer.borderWidth = 3
        button3.layer.borderWidth = 3
        
        button1.layer.borderColor = UIColor.darkGray.cgColor
        button2.layer.borderColor = UIColor.darkGray.cgColor
        button3.layer.borderColor = UIColor.darkGray.cgColor
       
    }
    
    func askQuestion(action: UIAlertAction!) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = (countries[correctAnswer].uppercased() + ", " + "Current score is \(score)")
        
        
    }
    func exitGame(action: UIAlertAction!){
        
        exit(0)
        
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        let tag = sender.tag
        counter += 1
        
        if tag == correctAnswer{
            title = "Correct!"
            score += 1
            message = "Your score is \(score)"
        } else {
            title = "Wrong!"
            score -= 1
            message = "That is the flag of \(countries[tag].uppercased()), Your score is \(score)"
        }
                
        if counter <= 10 {
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            
        } else {
            
            let acFinal = UIAlertController(title: "Game Over", message: "Game is over. Your final score is \(score)", preferredStyle: .alert)
            acFinal.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: exitGame))
            present(acFinal, animated: true)
            
        }
        
        
    }
    
    @objc func showScore(){
        let ss = UIAlertController(title: "SCORE", message: "current score is \(score)", preferredStyle: .alert)
        ss.addAction(UIAlertAction(title: "continue", style: .default, handler: nil))
        present(ss,animated: true)
    }
    
    func registerLocal(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {granted, error in
            if granted {
                print("yay!")
            } else {
                print("Nay")
            }
        }
    }
    
    func scheduleLocal(){
        
        registerCategories() //single button
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        
        //content to show
        content.title = "Lets Play!!" //kalın büyük başlık, ideali birkaç cümle
        content.body = "Dont you wonder how many flags you will guess today?" //ana mesaj text olabilir, imessage olabilir etc..
        content.categoryIdentifier =  "alarm" //custom action
        
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        //next step trigger = ne zaman gösterilecek? when to show
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600*24, repeats: true)
        
        //request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
         //foregorund = id the button is tapped lounch this app immediately
        let remindMeLater = UNNotificationAction(identifier: "remindMeLater", title: "remind me later", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [remindMeLater], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data recieved: \(customData)")
            switch response.actionIdentifier{
            case UNNotificationDefaultActionIdentifier:
                //the user swiped to unlock
                print("default identifier")
            case "remindMeLater":
                scheduleLocal()
            default:
                break
            }
        }
        
        completionHandler() // you must call the completion handler when you're done
    }
   
    
    
    
}

