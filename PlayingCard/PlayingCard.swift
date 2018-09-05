//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Thara Nagaraj on 13/08/18.
//  Copyright © 2018 Thara Nagaraj. All rights reserved.
//

import Foundation

//struct gets an automatic initializer
struct PlayingCard : CustomStringConvertible{
    
    var description: String{
        return ("\(rank)\(suit)")
    }
    
    var suit : Suit
    var rank : Rank
    
    //demonstrates raw value
    enum Suit: String, CustomStringConvertible{
        
        case spades = "♠️"
        case hearts = "❤️"
        case diamonds = "♦️"
        case clubs = "♣️"
        
        var description: String { return rawValue }
        static var all = [Suit.clubs, .diamonds,.hearts,.spades]
    }
    
    
    //demonstrates associated value
    enum Rank: CustomStringConvertible{
        var description: String{
            switch self {
            case .ace:
                return "1"
            case .numeric(let pips) : return String(pips)
            case .face(let type) : return type
            }
        }
        
        case ace
        case face(String)
        case numeric(Int)
        
        var order : Int? {
            switch self{
            case .ace: return 1
            case .numeric(let pips) : return pips
            case .face(let kind) where kind == "J" :return 11
            case .face(let kind) where kind == "Q" :return 12
            case .face(let kind) where kind == "K" :return 13
            default : return nil
            }
        }
        
        static var all : [Rank] {
            var allRanks : [Rank] = [.ace]
            for pips in 2...10{
                allRanks.append(Rank.numeric(pips))
            }
            //can infer from the second and third elements
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            
            return allRanks
        }
        
    }
}
