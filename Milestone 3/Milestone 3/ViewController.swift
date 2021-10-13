//
//  ViewController.swift
//  Milestone 3
//
//  Created by Hümeyra Şahin on 13.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var questionLabel: UILabel!
    var scoreLabel: UILabel!
    var remainLabel: UILabel!
    var falseGuessLabel: UILabel!
    
    var guessTextField: UITextField!
    
    var enterButton: UIButton!
    
    var word = ["GUESS","ONE","OCTOBER","NOVEMBER"]
    var guess = [String]()
    var answer = ""
    var newWord = ""
    var falseGuess = ""
   
    var score = 0 {
        didSet{
            scoreLabel.text = "score: \(score)"
        }
    }
    
    var remainChance = 7{
        didSet{
            remainLabel.text = "Remain Chances: \(remainChance)"
        }
        
    }
    
    var count = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "score: 0"
        view.addSubview(scoreLabel)
        
        remainLabel = UILabel()
        remainLabel.translatesAutoresizingMaskIntoConstraints = false
        remainLabel.textAlignment = .right
        remainLabel.text = "Remain Chances: 7"
        view.addSubview(remainLabel)
        
        questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.textAlignment = .center
        questionLabel.text = "??????"
        questionLabel.layer.borderColor = UIColor.darkGray.cgColor
        questionLabel.layer.borderWidth = 1
        questionLabel.font = UIFont.systemFont(ofSize: 24)
        questionLabel.numberOfLines = 1
        questionLabel.setContentHuggingPriority(UILayoutPriority(1) , for: .vertical)
        view.addSubview(questionLabel)
        
        guessTextField = UITextField()
        guessTextField.isUserInteractionEnabled = true
        guessTextField.translatesAutoresizingMaskIntoConstraints = false
        guessTextField.textAlignment = .center
        guessTextField.layer.borderWidth = 1
        guessTextField.layer.borderColor = UIColor.darkGray.cgColor
        guessTextField.placeholder = "enter a letter"
        guessTextField.font = UIFont.systemFont(ofSize: 18)
        guessTextField.setContentHuggingPriority(UILayoutPriority(1), for: NSLayoutConstraint.Axis.vertical)
        view.addSubview(guessTextField)
        
        enterButton = UIButton(type: .system)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        enterButton.layer.borderWidth = 1
        enterButton.layer.borderColor = UIColor.darkGray.cgColor
        enterButton.addTarget(self, action: #selector(enterTapped), for: .touchUpInside)
        
        enterButton.setTitle("ENTER", for: .normal)
        view.addSubview(enterButton)
        
        falseGuessLabel = UILabel()
        falseGuessLabel.translatesAutoresizingMaskIntoConstraints = false
        falseGuessLabel.textAlignment = .center
        falseGuessLabel.layer.borderWidth = 1
        falseGuessLabel.layer.borderColor = UIColor.darkGray.cgColor
        falseGuessLabel.numberOfLines = 1
        falseGuessLabel.text = "..........."
        falseGuessLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(falseGuessLabel)
        
        
        NSLayoutConstraint.activate([
        
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            remainLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            remainLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: remainLabel.bottomAnchor,constant: 50),
            questionLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            questionLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1, constant: -100),
            
            guessTextField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            guessTextField.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            guessTextField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1,constant: -200),
            guessTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 50),
            
            enterButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            enterButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            enterButton.widthAnchor.constraint(equalTo: guessTextField.widthAnchor, multiplier: 0.3, constant: 20),
            enterButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -50),
            
            
            falseGuessLabel.topAnchor.constraint(equalTo: guessTextField.bottomAnchor,constant: 50),
            falseGuessLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            falseGuessLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1, constant: -100),
            
        
        ])
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initial()
    }
    
    func initial(){
        questionLabel.text = ""
        falseGuessLabel.text = "...."
        falseGuess = ""
        newWord = ""
        guess.removeAll()
        count = 0
        word.shuffle()
        for _ in 0..<word[0].count{
            questionLabel.text! += "?"
        }
        print(word[0])
        answer = word[0]
        
    }
    func start(action: UIAlertAction){
        initial()
        
    }
    
    
    
    @objc func enterTapped(_ sender: UIButton){
        
        let letter = guessTextField.text?.uppercased()
        if answer.contains(letter!){
            guess.append(letter!)
            for char in answer {
                    if guess.contains(String(char)) {
                        newWord += String(char)
                    } else {
                        newWord += "?"
                }
            }
            questionLabel.text = newWord
            newWord = ""
            count += 1
            if count == word[0].count || !questionLabel.text!.contains("?"){
                score += 1
                if score == word.count{
                    score = 0
                    remainChance = 7
                    let ac = UIAlertController(title: "Congrats!", message: "you have guessed all the words!!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: start))
                    present(ac, animated: true)
                } else {
                    let ac = UIAlertController(title: "Congrats!", message: "word is correct!!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: start))
                    present(ac, animated: true)
                }
                
            }
            
            
        } else {
            falseGuess += (letter! + " ")
            remainChance -= 1
            falseGuessLabel.text = falseGuess
            if remainChance == 0 {
                falseGuess = ""
                let ac = UIAlertController(title: "UPS!", message: "word was \(word[0])!!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: start))
                present(ac, animated: true)
            }
            
        }
        
        guessTextField.text = ""
            
    
        
        
        
    }
    
    


}

