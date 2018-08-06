//
//  Concetration.swift
//  Concentration
//
//  Created by Salavat Shirgaleev on 7/29/18.
//  Copyright © 2018 Salavat Shirgaleev. All rights reserved.
//

import Foundation

struct Concentration {
    var gameScore = 0
    
    private(set) var cards = [Card]()
    
    var openedCards = [Int]()
    
    
    private var indexOfOneAndOnlyOneFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                       foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set  {
            for index in cards.indices {
                cards[index].isFaceUp = (index==newValue)
            }
        }
    }
    
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
    
    mutating func chooseCards(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCards(at: \(index): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    gameScore += 2
                }
                cards[index].isFaceUp = true
                if wasOpenedBefore(to: cards[index]) {
                    gameScore -= 1
                }
            } else {
                indexOfOneAndOnlyOneFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards : Int) {
        assert(numberOfPairsOfCards>0, "Concentration.init(\(numberOfPairsOfCards): you must have at least one pair of cards")
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
    
    mutating func wasOpenedBefore(to card :Card) -> Bool {
        if (openedCards.contains(card.hashValue)){
            return true
        } else{
            openedCards.append(card.hashValue)
            return false
        }
        
    }
    
    
    mutating func startNewGame(){
        gameScore = 0
        cards.removeAll()
        openedCards.removeAll()
        indexOfOneAndOnlyOneFaceUpCard = nil
        
    }
    
    
}
