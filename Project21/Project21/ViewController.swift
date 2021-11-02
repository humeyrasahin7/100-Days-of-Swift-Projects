//
//  ViewController.swift
//  Project21
//
//  Created by Hümeyra Şahin on 2.11.2021.
//

import UIKit
import UserNotifications


class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(firstScheduleLocal))
    }

    @objc func registerLocal(){ //permission to show to the user
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {granted, error in
            if granted {
                print("yay!")
            } else {
                print("Nay")
            }
        }
        
        
    }
    
    @objc func firstScheduleLocal(){
        scheduleLocal(timeInterval: 5)
    }
    
    func scheduleLocal(timeInterval: Double){
        registerCategories() //single button
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        
        //content to show
        content.title = "Late Wakeup Call" //kalın büyük başlık, ideali birkaç cümle
        content.body = "The early bird catches the worm, but the second mouse gets the cheese." //ana mesaj text olabilir, imessage olabilir etc..
        content.categoryIdentifier =  "alarm" //custom action
        
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        //next step trigger = ne zaman gösterilecek?
        //when to show
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        //request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "tell me more..", options: .foreground) //foregorund = id the button is tapped lounch this app immediately
        let remindMeLater = UNNotificationAction(identifier: "remindMeLater", title: "remind me later", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMeLater], intentIdentifiers: [], options: [])
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
                let ac = UIAlertController(title: "default identifier", message: "you didnt select any", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default)
                ac.addAction(ok)
                present(ac, animated: true)
            case "show":
                let ac = UIAlertController(title: "show more", message: "you selected show more info", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default)
                ac.addAction(ok)
                present(ac, animated: true)
            case "remindMeLater":
                scheduleLocal(timeInterval: 3600*24)
            default:
                break
            }
        }
        
        completionHandler() // you must call the completion handler when you're done
    }
    

}

