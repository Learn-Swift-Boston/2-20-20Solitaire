//
//  main.swift
//  Klondike
//
//  Created by Matt Dias on 2/20/20.
//  Copyright © 2020 Matt Dias. All rights reserved.
//

import Foundation

enum Suit: String, CaseIterable {
    case spades, clubs, hearts, diamonds
    
    var character: String {
        switch self {
        case .clubs:
            return "♣️"
        case .spades:
            return "♠️"
        case .hearts:
            return "♥️"
        case.diamonds:
            return "♦️"
        }
    }
}

enum Rank: Int, CaseIterable {
    case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
}

struct Card: CustomDebugStringConvertible {
    let rank: Rank
    let suit: Suit
    
    var debugDescription: String { "\(rank.rawValue)\(suit.character)" }
}

func buildShuffledDeck() -> [Card] {
    var deck: [Card] = []

    for suit in Suit.allCases {
        for rank in Rank.allCases {
            let card = Card(rank: rank, suit: suit)
            deck.append(card)
        }
    }

    return deck.shuffled()
}

func isStackable(stackCard: Card?, drawCard: Card) -> Bool {
    let result = (drawCard.rank == .ace && stackCard == nil) ||
        (stackCard?.suit == drawCard.suit && stackCard?.rank.rawValue == drawCard.rank.rawValue - 1)
    
    return result
}

var pile1: [Card] = []
var pile2: [Card] = []
var pile3: [Card] = []
var pile4: [Card] = []
var discardPile: [Card] = []

var shuffledDeck = buildShuffledDeck()
var shouldCheckDiscard = false
var loops = 0

func stack(card: Card) {
    if isStackable(stackCard: pile1.last, drawCard: card) {
        pile1.append(card)
        shouldCheckDiscard = true
    } else if isStackable(stackCard: pile2.last, drawCard: card) {
        pile2.append(card)
        shouldCheckDiscard = true
    } else if isStackable(stackCard: pile3.last, drawCard: card) {
        pile3.append(card)
        shouldCheckDiscard = true
    } else if isStackable(stackCard: pile4.last, drawCard: card) {
        pile4.append(card)
        shouldCheckDiscard = true
    } else {
        discardPile.append(card)
        shouldCheckDiscard = false
    }
}

func play(with deck: [Card]) {
    var deck = deck
    while deck.count > 0 {
        loops += 1
        
        if shouldCheckDiscard, let card = discardPile.popLast() {
            stack(card: card)
            continue
        }
        
        guard let card = deck.popLast() else { break }
        
        stack(card: card)
    }
    
    if discardPile.count > 0 {
        deck = discardPile
        discardPile = [Card]()
        play(with: deck)
    }
}

play(with: shuffledDeck)

print("deck: \(shuffledDeck)")
print("pile 1: \(pile1)")
print("pile 2: \(pile2)")
print("pile 3: \(pile3)")
print("pile 4: \(pile4)")
print("sorted in \(loops) loops")



/*
    Below, I wanted to see what the best and worst sorts would be in 1000 playthroughs
 */

var output = [Int]()

for _ in 1...1000 {
    pile1 = []
    pile2 = []
    pile3 = []
    pile4 = []
    discardPile = []

    shuffledDeck = buildShuffledDeck()
    shouldCheckDiscard = false
    loops = 0
    
    play(with: shuffledDeck)
    output.append(loops)
}

output.sort()
print("shortest run: \(output.first!)\nlongest run: \(output.last!)")
