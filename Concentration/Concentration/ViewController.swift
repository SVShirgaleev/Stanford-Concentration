//
//  ViewController.swift
//  Concentration
//
//  Created by Salavat Shirgaleev on 7/29/18.
//  Copyright © 2018 Salavat Shirgaleev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
    
    public lazy var emojiChoices = randomTheme()
    
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flip Count is : \(flipCount)"
            scoreLabel.text = "\(game.gameScore)"
            
        }
    }
    
   
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    
    
    
    @IBAction func touchCard(_ sender: UIButton) {
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
    
    func updateViewFromModel(){
        
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
    
    
    func flipCard (withEmoji emoji: String , on button : UIButton){
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = UIColor.orange
        } else {
            button.setTitle(emoji, for:UIControlState.normal)
            button.backgroundColor = UIColor.white
        }
    }
    
    var emoji  = [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil,(emojiChoices.count)>0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    
    
    
    var themesDictionary: Array<Array<String>> = [
        ["😀","😃","😄","😁","😆","😅","😂","🤣"],
        ["🐶","🐱","🐭","🐹","🐼","🐻","🦊","🐰"],
        ["🍏","🍎","🍐","🍊","🍇","🍉","🍌","🍋"],
        ["⚽️","🏀","🏈","⚾️","🎱","🏉","🏐","🎾"],
        ["🚗","🚕","🚙","🚌","🚑","🚓","🏎","🚎"],
        ["🏳️‍🌈","🏳️","🏴","🏁","🚩","🇦🇱","🇦🇽","🇦🇫"],
        ["🎃","👻", "🌙", "🌔", "⛈", "🌪", "🍙", "🔮"]
    ]
    
    
    func randomTheme()-> Array<String> {
        
        let randomNumber = Int(arc4random_uniform(UInt32(themesDictionary.count)))
        return themesDictionary[randomNumber]
        
    }
    
    
    
   
    @IBAction func newGameButton(_ sender: UIButton) {
        
            //game.startNewGame()
            flipCount = 0
            emojiChoices = randomTheme()
            game = Concentration(numberOfPairsOfCards: (cardButtons.count-1)/2)
        updateViewFromModel()
    }

    
    
    
}

