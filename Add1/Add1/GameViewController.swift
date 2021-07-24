//
//  ViewController.swift
//  Add1
//
//  Created by Kiefer Laptop on 4/27/21.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var timeLabel:UILabel?
    @IBOutlet weak var numberLabel:UILabel?
    @IBOutlet weak var inputField:UITextField?
    
    var score = 0
    var seconds = 60
    var numToGuess: [Int] = []
    var timer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    
    func startGame() {
        numToGuess = createRandomArray()
        updateScoreLabel()
        updateNumberLabel()
        updateTimeLabel()
        inputField?.text = ""
    }
    
    @IBAction func inputFieldDidChange() {
        guard let inputText = inputField?.text else {
            return
        }
        
        guard inputText.count == 4 else {
            return
        }
        
        
        var usersGuess = stringToArray(string: inputText)
        
        var isCorrect = true
        
        for i in 0..<4 {
                if usersGuess[i] == 0 {
                    usersGuess[i] = 10
                }
                if(numToGuess[i] + 1 != usersGuess[i]) {
                    isCorrect = false
                    break
                }
            }
            if isCorrect {
                score += 1
            }
            else {
                score -= 1
            }
            
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    if self.seconds == 0 {
                            self.finishGame()
                        }
                    else if self.seconds <= 60 {
                            self.seconds -= 1
                            self.updateTimeLabel()
                        }
                }
            }
        startGame()
    }
    
    func createRandomArray() -> [Int] {
        var array : [Int] = []
        
        for _ in 0..<4{
            array.append(Int.random(in: 0...9))
        }
        return array
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = String(score)
    }
    
    func updateNumberLabel() {
        numberLabel?.text = arrayToString(array: numToGuess)
    }
    
    func arrayToString(array: [Int]) -> String {
        var result = ""
        for i in 0..<4 {
            result += "\(array[i])"
        }
        return result
    }
    
    func stringToArray(string: String) -> [Int] {
        var array : [Int] = []
        for char in string {
            array.append(Int(String(char)) ?? 0)
        }
        return array
    }
    
    func updateTimeLabel() {

        //let min = (seconds / 60) % 60
        let sec = seconds

        timeLabel?.text = String(format: "%02d", sec)
    }
    
    func finishGame() {
        timer?.invalidate()
        timer = nil
        
        let alert = UIAlertController(title: "Time's Up!", message: "Your time is up! You got a score of \(score) points. Awesome!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK, start new game", style: .default, handler: {_ in
            self.score = 0
            self.seconds = 60
            self.startGame()
        }))

        self.present(alert, animated: true, completion: nil)
        
        updateTimeLabel()
        updateScoreLabel()
        updateNumberLabel()
    }

}
