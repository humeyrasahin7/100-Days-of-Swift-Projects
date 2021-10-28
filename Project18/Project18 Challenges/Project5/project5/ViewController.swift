//
//  ViewController.swift
//  project5
//
//  Created by Hümeyra Şahin on 6.10.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var cases = 0
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtForAnswer))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItems = [add, refresh]
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL) {
            allWords = startWords.components(separatedBy: "\n")
        }
        }
        if allWords.isEmpty{
            allWords = ["silkworm"]
        }
        startGame()
    }
    
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "words", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promtForAnswer(){
        
        let ac = UIAlertController(title: "Enter an answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "submit", style: .default){
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        
        let lowerAnswer = answer.lowercased()
        
        
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    usedWords.insert(answer, at: 0)
                    
                    let  indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    callErrorMessage()
                }
            } else {
                callErrorMessage()
            }
        } else {
            callErrorMessage()
        }
        
            
    }
    
    func isPossible(word: String) ->  Bool{
        
        guard var tempWord = title?.lowercased() else {return false}
        for letter in word{
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            } else {
                cases = 1
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool{
        if usedWords.contains(word){
            cases = 2
            return false
        } else {
            return true
        }
        
    }
    
    func isReal(word: String) -> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let length = word.utf16.count
        if length < 3 || word == title?.lowercased(){
            cases = 3
            return false
        }
        return misspelledRange.location == NSNotFound
    }
    
    func callErrorMessage(){
        
        let errorMessage: String
        let errorTitle: String
        
        
        
        switch cases {
        case 1:
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        case 2:
            errorTitle = "Word used already"
            errorMessage = "Be more original!"
        case 3:
            errorTitle = "Word is not valid"
            errorMessage = "Your word is either same as the original, smaller than 3 characters or unmeaningful, please try again."
        default:
            return
        }
    
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
            
    }
    
    
}

