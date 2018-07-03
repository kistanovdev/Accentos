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
    private var stressedFound: Bool
    private var word: String
    private var stressed: Int
    private var letterAccent: Int
    private var positions: [Int]
    
    init(word:String) {
        self.word = word.lowercased()
        self.stressedFound = false
        self.letterAccent = -1
        self.stressed = 0
        self.positions = []
        process()
    }
    public func getSyllables() -> [String] {
        var syllables = [String]()
        for i in 0...positions.count - 1 {
            let start = positions[i]
            var end = word.count
            if positions.count > i+1 {
                end = positions[i+1]
            }
            let syllable:String  = slice(input: word, from: start, to: end)
            syllables.append(syllable)
        }
        return syllables
    }
    /**
     Processes the word and returns indexes of syllables
     */
    private func process() {
        var numSyl = 0
        var i = 0
        //go through each index
        while i < word.count  {
            positions.append(i)
            numSyl += 1
            //check for different conditions and advance if needed
            i = onset(pos: &i)
            i = nucleus(pos: &i)
            i = coda(pos: &i)
            if stressedFound && stressed == 0 {
                stressed = numSyl
            }
        }
        // If the word has not written accent,
        //the stressed syllable is determined
        // according to the stress rules
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
    /**
      Determines the onset of the current syllable whose begins in pos
      and pos is changed to the follow position after end of onset.
      - parameter pos: current index
      - returns pos: processed position
     */
    private func onset(pos: inout Int) -> Int {
        var lastConsonant: Character = "a"
        
        while pos < word.count && (isConsonant(letter: charAt(at: pos)) && charAt(at: pos) != "y") {
            lastConsonant = charAt(at: pos)
            pos += 1
        }
        // (q | g) + u (example: queso, gueto)
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
                // The 'u' with diaeresis is added to the consonant
                pos += 1
                
            }
        }
        return pos
    }
    
    /**
     * Determines the nucleus of current syllable whose onset ending on pos - 1
     * and changes pos to the follow position behind of nucleus
     **/
    private func nucleus(pos:inout Int) -> Int {
        // Saves the type of previous vowel when two vowels together exists
        var previous:Int = 0
        // 0 = open
        // 1 = close with written accent
        // 2 = close
        if pos >= word.count {return pos}
        
        // Jumps a letter 'y' to the starting of nucleus, it is as consonant
        if charAt(at: pos) == "y" {pos += 1}
        
        // First vowel
        if pos < word.count {
            switch charAt(at: pos) {
            // Open-vowel or close-vowel with written accent
            case "á", "é", "ó" :
                letterAccent = pos
                stressedFound = true
                previous = 0
                pos += 1
            // Open-vowel
            case "a", "e", "o":
                previous = 0
                pos += 1
            // Close-vowel with written accent breaks some possible diphthong
            case "í", "ú", "ü":
                letterAccent = pos
                pos += 1
                stressedFound = true
                return pos
            // Close-vowel
            case "i", "u":
                previous = 2
                pos += 1
            default:
                print()
            }
        }
        // If 'h' has been inserted in the nucleus
        //then it doesn't determine diphthong neither hiatus
        var aitch:Bool = false
        if pos < word.count {
            if charAt(at: pos) == "h" {
                pos += 1
                aitch = true
            }
        }
        // Second vowel
        if pos < word.count {
            switch charAt(at: pos) {
            // Open-vowel with written accent
            case "á", "é", "ó":
                letterAccent = pos
                if previous != 0 {
                    stressedFound = true
                }
            // Open-vowel
            case "a", "e", "o":
                if previous == 0 {
                    if aitch {pos -= 1}
                    return pos
                } else {
                    pos += 1
                }
            // Close-vowel with written accent,
            // can't be a triphthong, but would be a diphthong
            case "í", "ú":
                letterAccent = pos
                if previous != 0 {
                    stressedFound = true
                    pos += 1
                } else if aitch {pos += 1}
                return pos
            // Close-vowel
            case "i", "u", "ü":
                if pos < word.count - 1 {
                    if !isConsonant(letter: charAt(at: pos+1)) {
                        if charAt(at: pos - 1) == "h" {pos += 1}
                        return pos
                    }
                }
                // Two equals close-vowels don't form diphthong
                if charAt(at: pos) != charAt(at: pos - 1) {pos += 1}
                // It is a descendent diphthong
                return pos
            default:
                break
            }
        }
        // Third vowel?
        if pos < word.count {
            if charAt(at: pos) == "i" || charAt(at: pos) == "u" {
                pos += 1
                // It is a triphthong
                return pos
            }
        }
        return pos
    }
    
    private func coda(pos:inout Int) -> Int {
        if pos >= word.count || !isConsonant(letter: charAt(at: pos)) {
            // Syllable hasn't coda
            return pos
        } else if pos == word.count - 1 {
            pos += 1
            return pos
        }
        // If there is only a consonant between vowels
        // it belongs to the following syllable
        if !isConsonant(letter: charAt(at: pos+1)) {
            return pos
        }
        
        let c1: Character = charAt(at: pos)
        let c2: Character = charAt(at: pos+1)
        
        
        // Has the syllable a third consecutive consonant?
        if pos < word.count - 2 {
            let c3: Character = charAt(at: pos+2)
            let pair: String = String(c1) + String(c2)
            
            if !isConsonant(letter: charAt(at: pos+2)) {
                
                // There isn't third consonant
                // The groups ll, ch and rr begin a syllable
                if ["ll","ch","rr"].contains(pair) {return pos}
                // A consonant + 'h' begins a syllable, except for groups sh and rh
                if c1 != "s" && c1 != "r" && c2 == "h" {return pos}
                
                // If the letter 'y' is preceded by the some
                // letter 's', 'l', 'r', 'n' or 'c' then
                //  a new syllable begins in the previous consonant
                // else it begins in the letter 'y'
                if c2 == "y" {
                    if "slrnc".contains(c1) {return pos}
                    pos += 1
                    return pos
                }
                // groups: gl - kl - bl - vl - pl - fl - tl
                if "bvckfgpt".contains(c1) && c2 == "l" {return pos}
                // groups: gr - kr - dr - tr - br - vr - pr - fr
                if "bvcdfgpt".contains(c1) && c2 == "r" {return pos}
                pos += 1
                return pos
            }  else {// There is a third consonant
                 // Three consonants to the end, foreign words?
                if pos+3 == word.count {
                    if c2 == "y" {// 'y' as vowel
                        if "slrnc".contains(c1) {return pos}
                    }
                    // 'y' at the end as vowel with c2
                    if c3 == "y" {
                        pos += 1
                    // Three consonants to the end, foreign words?
                    } else {
                        pos += 3
                    }
                    return pos
                }
                if c2 == "y" {// 'y' as vowel
                    if "slrnc".contains(c1) {
                        return pos
                    }
                    pos += 1
                    return pos
                }
                
                let pair:String = String(c2) + String(c2)
                // The groups pt, ct, cn, ps, mn, gn, ft, pn, cz, tz and ts begin a syllable
                // when preceded by other consonant
                if ["pt", "ct", "cn", "ps", "mn", "gn", "ft", "pn", "cz", "ts", "ts"].contains(pair) {
                    pos += 1
                    return pos
                }
                // The consonantal groups formed by a consonant
                // following the letter 'l' or 'r' cann't be
                // separated and they always begin syllable
                // 'ch'
                // 'y' as vowel
                if "lr".contains(c3) || (c2 == "c" && c3 == "h") || c3 == "y" {
                    pos += 1// Following syllable begins in c2
                } else {
                    pos += 2// c3 begins the following syllable

                }
                
            }
        } else {
            if c2 == "y" {
                return pos
            }
            pos += 2// The word ends with two consonants
        }
        return pos
    }
    private func isConsonant(letter:Character) -> Bool {
        return "bcdfghjklmnpqrstvwxyzñ".contains(letter)
    }
    //javalike function to get a char
    //Index.Strings aren't very comfortable to use
    private func charAt(at:Int) -> Character {
        return word[word.index(word.startIndex, offsetBy: at)]
    }
    //substring function using substring classes
    private func slice(input:String, from: Int, to: Int) -> String {
        let start = input.index(input.startIndex, offsetBy: from)
        let end = input.index(input.startIndex, offsetBy: to)
        let substring = start..<end
        return String(input[substring])
    }
}

