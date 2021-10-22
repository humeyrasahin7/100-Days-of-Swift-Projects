//
//  ViewController.swift
//  Project2
//
//  Created by Hümeyra Şahin on 2.10.2021.
//

import UIKit

class ViewController: UIViewController {

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
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.6, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        sender.transform = .identity
        
    }
    
    @objc func showScore(){
        let ss = UIAlertController(title: "SCORE", message: "current score is \(score)", preferredStyle: .alert)
        ss.addAction(UIAlertAction(title: "continue", style: .default, handler: nil))
        present(ss,animated: true)
    }
    
}

