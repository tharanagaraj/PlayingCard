//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Thara Nagaraj on 13/08/18.
//  Copyright © 2018 Thara Nagaraj. All rights reserved.
//

import Foundation
import UIKit


struct PlayingCardDeck
{
    private(set) var cards = [PlayingCard]()
    
    init(){
        for suit in PlayingCard.Suit.all{
            for rank in PlayingCard.Rank.all{
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
        
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else{
            return nil
        }
    }
}

extension Int{
    var arc4random : Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}


extension CGFloat{
    
    var arc4random: CGFloat {
          return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
    
}
//    var arc4random : CGFloat{
//        if self > 0{
//            return CGFloat(arc4random_uniform(UInt32(self)))
//        }else if self < 0{
//            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
//        }else{
//            return 0
//        }
//    }
//}
