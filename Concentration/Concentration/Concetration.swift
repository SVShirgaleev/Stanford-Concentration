//
//  Concetration.swift
//  Concentration
//
//  Created by Salavat Shirgaleev on 7/29/18.
//  Copyright © 2018 Salavat Shirgaleev. All rights reserved.
//

import Foundation

class Concentration {
    var gameScore = 0
    
    var cards = [Card]()
    
    var openedCards = [Int]()
    
    
    var indexOfOneAndOnlyOneFaceUpCard: Int?
    
    var isGameComplete: Bool {
        get {
        for card in cards {
            if !card.isMatched{
                return false
            }
        }
        return true
        }
    }
    
    func chooseCards(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    gameScore += 2
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyOneFaceUpCard = nil
                if wasOpenedBefore(for: cards[index].identifier) {
                    gameScore -= 1
                }
            } else {
                //either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyOneFaceUpCard = index
                
            }
        }
        
    }
    
    init(numberOfPairsOfCards : Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards+=[card, card]
        }
        var i = cards.count - 1
        while( i>=0){
            let randomNumber = Int(arc4random_uniform(UInt32(i)))
            let helpObject = cards[randomNumber]
            cards[randomNumber] = cards[i]
            cards[i] = helpObject
            i-=1
        }
     }
    
    func wasOpenedBefore(for id: Int) -> Bool {
        if (openedCards.contains(id)){
            return true
        } else{
            openedCards.append(id)
            return false
        }
    }
    
    
    func startNewGame(){
        gameScore = 0
        cards.removeAll()
        openedCards.removeAll()
        indexOfOneAndOnlyOneFaceUpCard = nil
        
    }
    
    
}
