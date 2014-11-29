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
    willSet(moves) {
        movesLabel.text = String(moves)
    }
    }//setter (wenn die variable gesetzt wird soll der moves label text auch gesetzt werden)
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
//        movesLabel.text = String(moves)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func newGameButton(sender: AnyObject) {
        newGame()
    }

    @IBAction func buttonSelect(sender: UIButton) {
        assert(sender.tag < cards.count, "Fewer cards than buttons")
        if sender.tag < cards.count && openedCardIndex != sender.tag && cards[sender.tag].matched == false {
            if gameStartTime == nil {
                gameStartTime = NSDate()
            }
            
            let card = cards[sender.tag]

            if openedCardIndex == nil {
                closeAllUnmatched()
                moves++
//                movesLabel.text = String(moves)
                openedCardIndex = sender.tag

            } else { //two cards open
                if card == cards[openedCardIndex!] {
                    card.matched = true
                    if winningMove() {
                        var message = "You won. Moves: \(moves)"

                        if gameStartTime != nil {
                            let completionTime = Int(gameStartTime!.timeIntervalSinceNow*(-1))
                            message += " Completion Time: \(completionTime) seconds"
                        }
                        
                        let winningAlert = UIAlertController(title: "Congratulations", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        winningAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: { action in
                            self.newGame()
                            }))
                        winningAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
                    
                        }))
                        presentViewController(winningAlert, animated: false, completion: nil)
                    }
                }
                openedCardIndex = nil
            }
            sender.setBackgroundImage(card.image, forState: UIControlState.Normal)
        }
    }
    
    func closeAllUnmatched() {
        for (var i = 0; i < cards.count; i++) {
            if cards[i].matched == false {
                buttons[i].setBackgroundImage(UIImage(named: "CardBackground"), forState: UIControlState.Normal)
            }
        }
    }
    
    func winningMove() -> Bool {
        for (var i = 0; i < cards.count; i++) {
            if cards[i].matched == false {
                return false
            }
        }
        return true
    }
    
    func shuffle () { //can only be called after initialization of cards array in ViewDidLoad
        
        var shuffledCards : [MemoryItem] = []
        
        do {
            let randomNumber = Int(arc4random_uniform(UInt32(cards.count))) //use swap instead; swap two elements
            shuffledCards.append(cards[randomNumber])
            cards.removeAtIndex(randomNumber)
        } while cards.count > 0
        
        cards = shuffledCards
    }
    
    func newGame () {
        for (var i = 0; i < cards.count; i++) {
            cards[i].matched = false
        }
        closeAllUnmatched()
        shuffle()
        moves = 0
//        movesLabel.text = String(moves)
        gameStartTime = nil
        openedCardIndex = nil
        
    }
}

