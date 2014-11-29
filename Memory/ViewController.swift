//
//  ViewController.swift
//  Memory
//
//  Created by Tanya Sahin on 11/22/14.
//  Copyright (c) 2014 Tanya Sahin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var movesLabel: UILabel!
    
    var cards : [MemoryItem] = []
    var openedCardIndex : Int?
    var moves : Int = 0 {
        didSet {
            movesLabel.text = String(moves)
        }
    }
    var gameStartTime : NSDate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let names = ["Apple", "Car", "Dog", "Flower", "Star", "Tree"]
        
        cards.removeAll(keepCapacity: false)
        for name in names {
            let item = MemoryItem(name: name)
            cards.append(item)
            cards.append(item)
        }
        shuffle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func newGameButton(sender: AnyObject) {
        newGame()
    }

    @IBAction func buttonSelect(sender: UIButton) { //change name to buttonTapped
        assert(sender.tag < cards.count, "Fewer cards than buttons")
        if sender.tag < cards.count && openedCardIndex != sender.tag && cards[sender.tag].matched == false {
            if gameStartTime == nil {
                gameStartTime = NSDate()
            }
            
            let card = cards[sender.tag]

            if let cardIndex = openedCardIndex? { //second card opened
                if card == cards[cardIndex] {
                    card.matched = true
                    if allMatched() {
                        var message = "You won. Moves: \(moves)"

                        if let startTime = gameStartTime? {
                            let completionTime = Int(startTime.timeIntervalSinceNow*(-1))
                            message += " Completion Time: \(completionTime) seconds"
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
    
    func shuffle () { //can only be called after initialization of cards array in ViewDidLoad
        
        var shuffledCards : [MemoryItem] = []
        
        while !cards.isEmpty {
            let randomNumber = Int(arc4random_uniform(UInt32(cards.count))) //use swap instead; swap two elements
            shuffledCards.append(cards[randomNumber])
            cards.removeAtIndex(randomNumber)
        }
        
        cards = shuffledCards
    }
    
    func newGame () {
        for card in cards {
            card.matched = false
        }
        closeAllUnmatched()
        shuffle()
        moves = 0
        gameStartTime = nil
        openedCardIndex = nil
    }
}

