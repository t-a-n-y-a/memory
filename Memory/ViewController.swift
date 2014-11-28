//
//  ViewController.swift
//  Memory
//
//  Created by Tanya Sahin on 11/22/14.
//  Copyright (c) 2014 Tanya Sahin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let nPairs = 6 //Number of Memory Pairs (Images)
    var cards : [MemoryItem] = []
    var openedCardIndex : Int?
    var nPairsFound = 0
    var pairFound = false
    @IBOutlet var buttons: [UIButton]!
    
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
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonSelect(sender: UIButton) {
        assert(sender.tag < cards.count, "Fewer cards than buttons")
        if sender.tag < cards.count {
            let card = cards[sender.tag]

            if openedCardIndex == nil {
                // close all unmatched cards
                for (var i = 0; i < cards.count; i++) {
                    if cards[i].matched == false {
                        buttons[i].setBackgroundImage(UIImage(named: "CardBackground"), forState: UIControlState.Normal)
                    }
                }
            }
            
            sender.setBackgroundImage(card.image, forState: UIControlState.Normal)
            if openedCardIndex == nil {
                openedCardIndex = sender.tag
            } else { //two cards open
                if card == cards[openedCardIndex!] {
                    card.matched = true
                    nPairsFound++
                }
                openedCardIndex = nil
            }
        }
    }
    
    func shuffle () { //can only be called after initialization of cards array in ViewDidLoad
        
        var shuffledCards : [MemoryItem] = []
        
        var randomNumber : Int
        for (var i = 0; i < 2*nPairs; i++) {
            randomNumber = Int(arc4random_uniform(UInt32(2*nPairs-i)))
            shuffledCards.append(cards[randomNumber])
            cards.removeAtIndex(randomNumber)
        }
        cards = shuffledCards
    }
    
    

//    func compareAndEvaluateCards (card : MemoryItem) {
//        if card.image != cards[openedCard].image {//CHECK (!)
//            pairFound = false
//            openedCard = nil
//        }
//        if card.image == cards[openedCard].image {//CHECK (!) as above
//            openedCard = nil
//            nPairsFound++
//            if nPairsFound == nPairs {
//                //DISPLAY WINNING MESSAGE; END OF GAME (ask if want to start new game etc
//            }
//        }
//
//    }
}

