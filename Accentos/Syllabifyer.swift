//
//  Syllabifyer.swift
//  Accentos
//
//  Created by Daniil on 6/22/18.
//  Copyright © 2018 Daniil Kistanov. All rights reserved.
//

import Foundation
import UIKit

class Syllabifyer {
    var stressedFound: Bool
    var word: String
    var stressed: Int
    var letterAccent: Int
    var positions: [Int]
    
    init(word:String) {
        self.word = word.lowercased()
        self.stressedFound = false
        self.letterAccent = -1
        self.stressed = 0
        self.positions = []
        print(word)
        process()
    }
    func getSyllables() -> [String] {
        var syllables = [String]()
        for i in 0...positions.count-1 {
            var start = positions[i]
            var end = word.count
            if positions.count > i+1 {
                end = positions[i+1]
            }
            let syllable:String  = slice(input: word, from: start, to: end)
            syllables.append(syllable)
        }
        return syllables
    }
    func process() {
        var numSyl = 0
        var i = 0
        while i < word.count  {
            positions.append(i)
            numSyl += 1
            i = onset(pos: &i)
            i = nucleus(pos: &i)
            i = coda(pos: &i)
            if stressedFound && stressed == 0 {
                stressed = numSyl
            }
        }
        
        if !stressedFound {
            if numSyl < 2 {
                stressed = numSyl
            } else {
                let endLetter: Character = charAt(at:word.count - 1)
                
                let temp:Bool = !isConsonant(letter: charAt(at: word.count - 1))
                let temp2:Bool = !isConsonant(letter: charAt(at: word.count - 2))
                
                if (temp || endLetter == "y") || (endLetter == "n" || endLetter == "s" && temp2){
                    stressed = numSyl - 1
                } else {
                    stressed = numSyl
                }
            }
        }
    }
    
    func onset(pos: inout Int) -> Int {
        var lastConsonant: Character = "a"
        
        while pos < word.count && (isConsonant(letter: charAt(at: pos)) && charAt(at: pos) != "y") {
            lastConsonant = charAt(at: pos)
            pos += 1
        }
        
        if pos < word.count - 1 {
            if charAt(at: pos) == "u" {
                if lastConsonant == "q" {
                    pos += 1
                } else if lastConsonant == "g" {
                    let letter:Character = charAt(at: pos+1)
                    if "eéií".contains(letter) {
                        pos += 1
                    }
                }
            } else if charAt(at: pos) == "ü" &&  lastConsonant == "g"{
                pos += 1
                
            }
        }
        return pos
    }
    
    
    func nucleus(pos:inout Int) -> Int {
        var previous:Int = 0
        
        if pos >= word.count {return pos}
        
        if charAt(at: pos) == "y" {pos += 1}
        
        if pos < word.count {
            switch charAt(at: pos) {
            case "á", "é", "ó" :
                letterAccent = pos
                stressedFound = true
                break
            case "a", "e", "o":
                previous = 0
                pos += 1
            case "í", "ú", "ü":
                letterAccent = pos
                pos += 1
                stressedFound = true
                return pos
            case "i", "u":
                previous = 2
                pos += 1
            default:
                break
            }
        }
        
        var aitch:Bool = false
        if pos < word.count {
            if charAt(at: pos) == "h" {
                pos += 1
                aitch = true
            }
        }
        
        if pos < word.count {
            switch charAt(at: pos) {
            case "á", "é", "ó":
                letterAccent = pos
                if previous != 0 {
                    stressedFound = true
                }
            case "a", "e", "o":
                if previous == 0 {
                    if aitch {pos -= 1}
                    return pos
                } else {
                    pos += 1
                }
            case "í", "ú":
                letterAccent = pos
                if previous != 0 {
                    stressedFound = true
                    pos += 1
                } else if aitch {pos += 1}
                return pos
            case "i", "u", "ü":
                if pos < word.count - 1 {
                    if !isConsonant(letter: charAt(at: pos+1)) {
                        if charAt(at: pos - 1) == "h" {pos += 1}
                        return pos
                    }
                }
                if charAt(at: pos) != charAt(at: pos - 1) {pos += 1}
                return pos
            default:
                break
            }
        }
        if pos < word.count {
            if charAt(at: pos) == "i" || charAt(at: pos) == "u" {
                pos += 1
                return pos
            }
        }
        return pos
    }
    
    func coda(pos:inout Int) -> Int {
        if pos >= word.count || !isConsonant(letter: charAt(at: pos)) {
            return pos
        } else if pos == word.count - 1 {
            pos += 1
            return pos
        }
        
        if !isConsonant(letter: charAt(at: pos+1)) {
            return pos
        }
        
        let c1: Character = charAt(at: pos)
        let c2: Character = charAt(at: pos+1)
        let c3: Character = charAt(at: pos+2)
        if pos < word.count - 2 {
            
            let pair: String = String(c1) + String(c2)
            if !isConsonant(letter: charAt(at: pos+2)) {
                if ["ll","ch","rr"].contains(pair) {return pos}
                if c1 != "s" && c1 != "r" && c2 == "h" {return pos}
                
                if c2 == "y" {
                    if "slrnc".contains(c1) {return pos}
                    pos += 1
                    return pos
                }
                if "bvckfgpt".contains(c1) && c2 == "l" {return pos}
                
                if "bvcdfgpt".contains(c1) && c2 == "r" {return pos}
                pos += 1
                return pos
            }  else {
                if pos+3 == word.count {
                    if c2 == "y" {
                        if "slrnc".contains(c1) {return pos}
                    }
                    if c3 == "y" {
                        pos += 1
                    } else {
                        pos += 3
                    }
                    return pos
                }
                if c2 == "y" {
                    if "slrnc".contains(c1) {
                        return pos
                    }
                    pos += 1
                    return pos
                }
                
                let pair:String = String(c2) + String(c2)
                
                if ["pt", "ct", "cn", "ps", "mn", "gn", "ft", "pn", "cz", "ts", "ts"].contains(pair) {
                    pos += 1
                    return pos
                }
                if "lr".contains(c3) || (c2 == "C" && c3 == "h") || c3 == "y" {
                    pos += 1
                } else {
                    pos += 2
                }
                
            }
        } else {
            if c2 == "y" {
                return pos
            }
            pos += 2
        }
        return pos
    }
    func isConsonant(letter:Character) -> Bool {
        return "bcdfghjklmnpqrstvwxyzñ".contains(letter)
    }
    func charAt(at:Int) -> Character {
        return word[word.index(word.startIndex, offsetBy: at)]
    }
    func slice(input:String, from: Int, to: Int) -> String {
        let start = input.index(input.startIndex, offsetBy: from)
        let end = input.index(input.startIndex, offsetBy: to)
        let substring = start..<end
        return String(input[substring])
    }
}

