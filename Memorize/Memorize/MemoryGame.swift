//
//  MemoryGame.swift
//  Memorize
//
//  Created by Scott Gulbin on 6/7/20.
//  Copyright © 2020 Scott Gulbin. All rights reserved.
//

import Foundation
//<CardContent> declares that is is a generic type
struct MemoryGame<CardContent> where CardContent: Equatable{
    var cards: Array<Card>
    var score = 0
    
    var indexOfTheOneandOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
            if let potentialMatchIndex = indexOfTheOneandOnlyFaceUpCard{
                if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    if (card.bonusRemaining > 0)
                    {
                        score += 5
                    }
                    score += 2
                } else if(!cards[chosenIndex].isShown && !cards[potentialMatchIndex].isShown) {
                    cards[chosenIndex].isShown = true
                    cards[potentialMatchIndex].isShown = true
                } else if (cards[chosenIndex].isShown || cards[potentialMatchIndex].isShown) {
                    score -= 1
                    if(cards[chosenIndex].isShown && cards[potentialMatchIndex].isShown) {
                        score -= 1
                    }
                    cards[chosenIndex].isShown = true
                    cards[potentialMatchIndex].isShown = true
                }
                self.cards[chosenIndex].isFaceUp = true

            }else{
                indexOfTheOneandOnlyFaceUpCard = chosenIndex
            }
        }
    }
    

    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        
        for pairIndex in 0..<Int.random(in: 2..<5) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct  Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        var isShown: Bool = false
        
        
        
        
        
        
        
        
        // MARK: - Bonus Time
        
        // this could give us matching bonus points
        // if the user matches the card before a certain amount of time
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long the card has been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // accumulated time this card has been face up in the past
        // not including current time it's been face up if currently so
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before bonus oppurtunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // whether we are currently fae up, unmatched and have not yet used the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
