//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Scott Gulbin on 6/7/20.
//  Copyright © 2020 Scott Gulbin. All rights reserved.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject{
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    
    static func createMemoryGame() -> MemoryGame<String>{
        let spooks: Array<String> = ["👻","🎃","🕷","🕸","💀","😈","🌒","🍂","🍁","🙀","☠️","👺"]
        let sports: Array<String> = ["⚽️","⛳️","🏉","⚾️","🏀","🥏","🏋️","🏄‍♂️","🧘‍♂️","⛸","🏑","🎣"]
        let food: Array<String> = ["🥑","🥦","🍖","🥨","🍓","🍌","🍈","🍑","🥗","🥖","🍱","🥓"]
        let animals: Array<String> = ["🐶","🐱","🐭","🐹","🐸","🦊","🐔","🐤","🐨","🦄","🐣","🦇"]
        let city: Array<String> = ["🚎","🚛","🚆","🛴","🚦","✈️","🚞","🏍","🚁","🚔","🛺"]
        let tech: Array<String> = ["📱","⌚️","🖥","🖨","⌨️","💻","📷","📟","☎️","🖲","💽","🔦"]
        let emojis: Array = [spooks, sports, food, animals, city, tech].shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: emojis.first!.count){ pairIndex in return emojis.first![pairIndex]} //inline function (closure)
    }
    
    func getTheme() -> String{
        let first = model.cards[0].content
        let spooks: Array<String> = ["👻","🎃","🕷","🕸","💀","😈","🌒","🍂","🍁","🙀","☠️","👺"]
        let sports: Array<String> = ["⚽️","⛳️","🏉","⚾️","🏀","🥏","🏋️","🏄‍♂️","🧘‍♂️","⛸","🏑","🎣"]
        let food: Array<String> = ["🥑","🥦","🍖","🥨","🍓","🍌","🍈","🍑","🥗","🥖","🍱","🥓"]
        let animals: Array<String> = ["🐶","🐱","🐭","🐹","🐸","🦊","🐔","🐤","🐨","🦄","🐣","🦇"]
        let city: Array<String> = ["🚎","🚛","🚆","🛴","🚦","✈️","🚞","🏍","🚁","🚔","🛺","🗽"]
        let tech: Array<String> = ["📱","⌚️","🖥","🖨","⌨️","💻","📷","📟","☎️","🖲","💽","🔦"]
        if (spooks.contains(first)){
            return "Spooks"
        }else if (sports.contains(first)){
            return "Sports"
        }else if (food.contains(first)){
            return "Food"
        }else if (animals.contains(first)){
            return "Animals"
        }else if (city.contains(first)){
            return "City"
        }else if (tech.contains(first)){
            return "Tech"
        }
        return "No Theme"
    }
    
    
    func shuffleTheme(){
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    func getScore() -> Int{
        return model.score
    }
    
    //MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    
    
    //MARK: -Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
