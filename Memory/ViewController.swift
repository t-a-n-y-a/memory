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
        let secs = abs(Int(self))
        let mins = secs/60
        let hours = mins/60
        
        if hours >= 1 {
            return "\(hours)h \(mins-hours*60)m \(secs-hours*60*60-((mins-hours*60)*60))s"
        }
        if mins >= 1 {
            return "\(mins) min \(secs-hours*60*60-((mins-hours*60)*60)) sec"
        }
        return (secs == 1 ? "\(secs) second" : "\(secs) seconds")
    }
    
    func formattedForTimer() -> String {
        let secs = abs(Int(self))
        let mins = secs/60
        let hours = mins/60
        
        if hours >= 1 {
            return "\(hours):\(mins-hours*60):\(secs-hours*60*60-((mins-hours*60)*60))"
        }
        if mins >= 1 {
            return "\(mins):\(secs-hours*60*60-((mins-hours*60)*60))"
        }
        return "\(secs)"
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
            movesLabel.text = String(moves)
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
                let aSelector : Selector = "updateTime"
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            }
            
            let card = cards[sender.tag]

            if let cardIndex = openedCardIndex? { //second card opened
                if card == cards[cardIndex] {
                    card.matched = true
                    if allMatched() {
                        var message = "You won. Moves: \(moves)"

                        if let startTime = gameStartTime? {
                            let completionTime = startTime.timeIntervalSinceNow.formattedForMessage()
                            gameStartTime = nil //needed so that timer stops as well
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
        if let startTime = gameStartTime? {
            let timeElapsed = startTime.timeIntervalSinceNow.formattedForTimer()
            timeElapsedLabel.text = "\(timeElapsed)"
        }
        
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
        timeElapsedLabel.text = "0"
    }
}

