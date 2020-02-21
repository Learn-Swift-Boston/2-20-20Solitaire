//
//  main.swift
//  Klondike
//
//  Created by Matt Dias on 2/20/20.
//  Copyright © 2020 Matt Dias. All rights reserved.
//

import Foundation

enum Suit: CaseIterable {
    case spades, clubs, hearts, diamonds
}

enum Rank: Int, CaseIterable {
    case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
}

struct Card {
    let rank: Rank
    let suit: Suit
}

func isStackable(stackCard: Card?, drawCard: Card) -> Bool {
    let result = (drawCard.rank == .ace && stackCard == nil) ||
        (stackCard?.suit == drawCard.suit &&
         stackCard?.rank.rawValue == drawCard.rank.rawValue - 1)
    return result
}

func buildShuffledDeck() -> [Card] {
    var deck: [Card] = []

    for suit in Suit.allCases {
        for rank in Rank.allCases {
            let card = Card(rank: rank, suit: suit)
            deck.append(card)
        }
    }

    return deck.shuffled().shuffled().shuffled()
}

var pile1: [Card] = []
var pile2: [Card] = []
var pile3: [Card] = []
var pile4: [Card] = []
var discardPile: [Card] = []

var deck = buildShuffledDeck()

func stack(card: Card) -> Bool {

    if isStackable(stackCard: pile1.last, drawCard: card) {
        pile1.append(card)
        return true
    } else if isStackable(stackCard: pile2.last, drawCard: card) {
        pile2.append(card)
        return true
    } else if isStackable(stackCard: pile3.last, drawCard: card) {
        pile3.append(card)
        return true
    } else if isStackable(stackCard: pile4.last, drawCard: card) {
        pile4.append(card)
        return true
    } else {
        return false
    }
}

// set up the intial state
discardPile.append(deck.popLast()!)

while !stack(card: discardPile.last!) {
    discardPile.append(deck.popLast()!)
}

print("pile 1: \(pile1)")
print("pile 2: \(pile2)")
print("pile 3: \(pile3)")
print("pile 4: \(pile4)")
print("discard: \(discardPile)")
print("deck: \(deck)")
