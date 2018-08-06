//
//  ViewController.swift
//  Concentration
//
//  Created by Salavat Shirgaleev on 7/29/18.
//  Copyright © 2018 Salavat Shirgaleev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
            return (cardButtons.count+1)/2
    }
    
    private lazy var emojiChoices = randomTheme()
    
    
    private (set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
             scoreLabel.text = "\(game.gameScore)"
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
       
    }
    
    
    
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    
   
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber  = cardButtons.index(of: sender){
            game.chooseCards(at: cardNumber)
            updateViewFromModel()
            // flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
        } else {
            print (" chosen card was not in cardButton")
        }
        if (game.isGameComplete) {
            updateViewFromModel()
        }
        
        print (game.isGameComplete)
    }
    
    private func updateViewFromModel(){
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle (emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor =  card.isMatched  ? #colorLiteral(red: 0.4340101523, green: 0.4340101523, blue: 0.4340101523, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                
            }
        }
    }
    
    
    private func flipCard (withEmoji emoji: String , on button : UIButton){
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = UIColor.orange
        } else {
            button.setTitle(emoji, for:UIControlState.normal)
            button.backgroundColor = UIColor.white
        }
    }
    
    private var emoji  = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil,(emojiChoices.count)>0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    
    
    
    private var themesDictionary: Array<String> = [
        "😀😃😄😁😆😅😂🤣",
        "🐶🐱🐭🐹🐼🐻🦊🐰",
        "🍏🍎🍐🍊🍇🍉🍌🍋",
        "⚽️🏀🏈⚾️🎱🏉🏐🎾",
        "🚗🚕🚙🚌🚑🚓🏎🚎",
        "🏳️‍🌈🏳️🏴🏁🚩🇦🇱🇦🇽🇦🇫",
        "🎃👻🌙🌔⛈🌪🍙🔮"
]
    
    
    private func randomTheme()-> String {
        
        let randomNumber = Int(arc4random_uniform(UInt32(themesDictionary.count)))
        return themesDictionary[randomNumber]
        
    }
    
    
    
    
    @IBAction private func newGameButton(_ sender: UIButton) {
        
        //game.startNewGame()
        flipCount = 0
        emojiChoices = randomTheme()
        game = Concentration(numberOfPairsOfCards: (cardButtons.count-1)/2)
        updateViewFromModel() 
    }
    
    
    
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

