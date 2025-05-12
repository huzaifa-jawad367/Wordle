//
//  WordBank.swift
//  Wordle
//
//  Created by Huzaifa Jawad on 12/05/2025.
//


import Foundation

/// A simple word‐list provider for Wordle
struct WordBank {
    /// Your full list of valid 5-letter words
    static let allWords: [String] = [
        "ABOUT","ABOVE","ABUSE","ACTOR","ACUTE","ADMIT","ADULT","AGENT","ALARM","ALBUM",
        "ALERT","ALIKE","ALIVE","ALLOW","ALONE","ALONG","ALTER","AMONG","ANGEL","ANGER",
        "ANGLE","ANKLE","BEACH","BEGIN","BLAME","BLANK","BOARD","BRAIN","BREAK","BRIEF",
        "BRING","BROAD","BROWN","BUILD","BULKY","BUYER","CABLE","CARRY","CATCH","CAUSE",
        "CHAIN","CHART","CHEAP","CHECK","CHEST","CIVIC","CLOUD","COULD","COUNT","COURT",
        "COVER","CRAFT","CRIME","CROSS","CROWD","CROWN","DAILY","DANCE","DECAY","DELAY",
        "DEPTH","DOUBT","DREAM","DRINK","DRIVE","EAGER","EARTH","ENJOY","ENTER","EQUAL",
        "ERROR","EVENT","EVERY","EXACT","EXIST","FAINT","FAITH","FAVOR","FEAST","FIBER",
        "FIELD","FINAL","FLOOD","FOCUS","FORCE","FRAME","FRONT","FRUIT","FUNNY","GLASS",
        "GRACE","GRADE","GRAIN","GRAPH","GRASS","GREAT","GREEN","GROUP","GUIDE","HABIT"
    ]

    /// Returns a random word from the bank
    static func randomWord() -> String {
        allWords.randomElement()!
    }
}
