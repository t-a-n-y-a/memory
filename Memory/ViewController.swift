//
//  ViewController.swift
//  Memory
//
//  Created by Tanya Sahin on 11/22/14.
//  Copyright (c) 2014 Tanya Sahin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cards : [MemoryItem] = []
    var openedCardIndex : Int?
    var nPairsFound = 0
    var moves = 0
    var timestamp : NSDate?
    var firstCard = true
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var movesLabel: UILabel!
    

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
        movesLabel.text = String(moves)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newGameButton(sender: AnyObject) {
        newGame()
    }

    @IBAction func buttonSelect(sender: UIButton) {
        assert(sender.tag < cards.count, "Fewer cards than buttons")
        if sender.tag < cards.count && openedCardIndex != sender.tag && cards[sender.tag].matched == false {
            if firstCard {
                timestamp = NSDate()
                firstCard = false
            }
            
            let card = cards[sender.tag]

            if openedCardIndex == nil {
                // close all unmatched cards
                for (var i = 0; i < cards.count; i++) {
                    if cards[i].matched == false {
                        buttons[i].setBackgroundImage(UIImage(named: "CardBackground"), forState: UIControlState.Normal)
                    }
                }
                moves++
                movesLabel.text = String(moves)
            }
            
            sender.setBackgroundImage(card.image, forState: UIControlState.Normal)
            if openedCardIndex == nil {
                openedCardIndex = sender.tag
            } else { //two cards open
                if card == cards[openedCardIndex!] {
                    card.matched = true
                    nPairsFound++
                    if nPairsFound == cards.count/2 {
                        var message = "You won. Moves: \(moves)"

                        if timestamp != nil {
                            let completionTime = Int(timestamp!.timeIntervalSinceNow*(-1))
                            message += " Completion Time: \(completionTime) seconds"
                        }
                        
                        let winningAlert = UIAlertController(title: "Congratulations", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        winningAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: { action in
                            self.newGame()
                            }))
                        winningAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
                    
                        }))
                        winningAlert.popoverPresentationController?.sourceView = sender as UIView
                        presentViewController(winningAlert, animated: false, completion: nil)
                    }
                }
                openedCardIndex = nil
            }
        }
    }
    
    func shuffle () { //can only be called after initialization of cards array in ViewDidLoad
        
        var shuffledCards : [MemoryItem] = []
        
        do {
            let randomNumber = Int(arc4random_uniform(UInt32(cards.count-1)))
            shuffledCards.append(cards[randomNumber])
            cards.removeAtIndex(randomNumber)
        } while cards.count > 0
        
        cards = shuffledCards
    }
    
    func newGame () {
        for (var i = 0; i < cards.count; i++) {
            buttons[i].setBackgroundImage(UIImage(named: "CardBackground"), forState: UIControlState.Normal)
            cards[i].matched = false
        }
        shuffle()
        moves = 0
        movesLabel.text = String(0)
        nPairsFound = 0
        firstCard = true
    }
}

