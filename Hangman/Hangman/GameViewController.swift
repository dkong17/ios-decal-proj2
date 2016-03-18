//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

extension String {
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start: start, end: end)]
    }
}

class GameViewController: UIViewController {
    @IBOutlet weak var hangmanImageView: UIImageView!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var Row1: UIStackView!
    
    var guesses : Int = 0
    var phrase : String = ""
    var currentGuess : String = ""
    
    var hangmanImages: [UIImage] = [
        UIImage(named: "hangman1.gif")!,
        UIImage(named: "hangman2.gif")!,
        UIImage(named: "hangman3.gif")!,
        UIImage(named: "hangman4.gif")!,
        UIImage(named: "hangman5.gif")!,
        UIImage(named: "hangman6.gif")!,
        UIImage(named: "hangman7.gif")!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newGame() {
        phrase = HangmanPhrases().getRandomPhrase()
        resetGame()
    }
    
    func resetGame() {
        currentGuess = ""
        print(phrase)
        for c in phrase.characters {
            if c != " " {
                currentGuess.append("-" as Character)
            } else {
                currentGuess.append(c)
            }
        }
        guesses = 0
        for view in self.view.subviews as [UIView] {
            if let stckview = view as? UIStackView {
                for btns in stckview.arrangedSubviews {
                    if let btn = btns as? UIButton {
                        btn.enabled = true
                        btn.alpha = 1.0
                    }
                }
            }
        }
        setHangmanImage()
        setPhraseLabel()
    }
    
    func setPhraseLabel() {
        phraseLabel.text = currentGuess
    }
    
    func setHangmanImage() {
        hangmanImageView.image = hangmanImages[guesses]
    }
    
    func endGame() {
        var endMessage : String = ""
        if guesses == 6 {
            endMessage = "You blow"
        }
        else if phrase == currentGuess {
            endMessage = "EY"
        }
        let alert = UIAlertController(title: endMessage, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Replay", style: UIAlertActionStyle.Default, handler: {action in
            self.resetGame()
        }))
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: {action in
            self.newGame()
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func makeGuess(sender: AnyObject) {
        if !(guesses < 6) { return }
        let button = sender as! UIButton
        let guessedChar = button.currentTitle!
        var positions : [Int] = []
        for i in Range(start: 0, end: phrase.characters.count) {
            if phrase[i] == guessedChar {
                positions.append(i)
            }
        }
        if positions.isEmpty {
            guesses += 1
        } else {
            for i in positions {
                currentGuess.removeAtIndex(currentGuess.startIndex.advancedBy(i))
                currentGuess.insertContentsOf(guessedChar.characters, at: currentGuess.startIndex.advancedBy(i))
            }
        }
        button.enabled = false
        button.alpha = 0.5
        setPhraseLabel()
        setHangmanImage()
        if guesses == 6 || phrase == currentGuess {
            endGame()
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        let shake_alert = UIAlertController(title: nil, message: "Restart puzzle?", preferredStyle: UIAlertControllerStyle.Alert)
        shake_alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        shake_alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in
            self.resetGame()
        }))

        if motion == .MotionShake {
            self.presentViewController(shake_alert, animated: true, completion: nil)
        }
    }

}
