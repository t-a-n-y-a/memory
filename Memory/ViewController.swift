//
//  ViewController.swift
//  Memory
//
//  Created by Tanya Sahin on 11/22/14.
//  Copyright (c) 2014 Tanya Sahin. All rights reserved.
//

import UIKit

extension NSTimeInterval {
    func formattedForMessage() -> String {
        
        let splittedInterval = self.splitHHMMSS()
        
        if splittedInterval.hours >= 1 {
            return "\(splittedInterval.hours)h \(splittedInterval.mins)m \(splittedInterval.secs)s"
        }
        if splittedInterval.mins >= 1 {
            return "\(splittedInterval.mins) min \(splittedInterval.secs) sec"
        }
        return (splittedInterval.secs == 1 ? "\(splittedInterval.secs) second" : "\(splittedInterval.secs) seconds")
    }
    
    func formattedForTimer() -> String {
        
        let splittedInterval = self.splitHHMMSS()
        
        if splittedInterval.hours >= 1 {
            return String(format: "%02d:%02d:%02d", splittedInterval.hours, splittedInterval.mins, splittedInterval.secs)
        }
        if splittedInterval.mins >= 1 {
            return String(format: "%02d:%02d", splittedInterval.mins, splittedInterval.secs)
        }
        return String(format: "00:%02d", splittedInterval.secs)
    }
    
    func splitHHMMSS() -> (hours: Int, mins: Int, secs: Int) {
        var secs = abs(Int(self))
        
        let hours = secs / 3600
        secs = secs % 3600
        
        let mins = secs / 60
        secs = secs % 60
        
        return (hours, mins, secs)
    }
}

class ViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    final var cards : [MemoryItem] = []
    var openedCardIndex : Int?
    var gameStartTime : NSDate?
    var timer : NSTimer?
    var moves : Int = 0 {
        didSet {
            movesLabel.text = "\(moves)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let names = ["Apple", "Car", "Dog", "Flower", "Star", "Tree"]
        
        cards.removeAll(keepCapacity: false)
        for name in names {
            let item = MemoryItem(name: name)
            cards.append(item)
            cards.append(item)
        }
        cards.shuffle()
        updateTime()
        moves = 0 //set movesLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func newGameButton(sender: AnyObject) {
        newGame()
    }

    @IBAction func buttonTapped(sender: UIButton) { //change name to buttonTapped
        assert(sender.tag < cards.count, "Fewer cards than buttons")
        if sender.tag < cards.count && openedCardIndex != sender.tag && cards[sender.tag].matched == false {
            if gameStartTime == nil {
                gameStartTime = NSDate()
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime", userInfo: nil, repeats: true)
            }
            
            let card = cards[sender.tag]

            if let cardIndex = openedCardIndex? { //second card opened
                if card == cards[cardIndex] {
                    card.matched = true
                    if allMatched() {
                        timer?.invalidate()
                        timer = nil
                        
                        var message = "You won. Moves: \(moves)"

                        if let startTime = gameStartTime? {
                            let completionTime = startTime.timeIntervalSinceNow.formattedForMessage()
                            message += " Completion Time: \(completionTime)"
                        }
                        
                        let winningAlert = UIAlertController(title: "Congratulations", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        winningAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
                        }))
                        
                        winningAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: { action in
                            self.newGame()
                        }))
                        presentViewController(winningAlert, animated: false, completion: nil)
                    }
                }
                openedCardIndex = nil
            } else { //first card opened
                closeAllUnmatched()
                moves++
                openedCardIndex = sender.tag
            }
            sender.setBackgroundImage(card.image, forState: UIControlState.Normal)
        }
    }
    
    func updateTime() {
        let timeInterval : NSTimeInterval = (gameStartTime != nil ? gameStartTime!.timeIntervalSinceNow : 0)
        let timeElapsed = timeInterval.formattedForTimer()
        timeElapsedLabel.text = "\(timeElapsed)"
//        NSLog("Time elapsed: %@", timeElapsed)
    }
    
    func closeAllUnmatched() {
        for (index, card) in enumerate(cards) {
            if card.matched == false {
                buttons[index].setBackgroundImage(UIImage(named: "CardBackground"), forState: UIControlState.Normal)
            }
        }
    }
    
    func allMatched() -> Bool {
        for card in cards {
            if card.matched == false {
                return false
            }
        }
        return true
    }
    
    func newGame () {
        for card in cards {
            card.matched = false
        }
        closeAllUnmatched()
        cards.shuffle()
        moves = 0
        gameStartTime = nil
        openedCardIndex = nil
        updateTime()
    }
}

