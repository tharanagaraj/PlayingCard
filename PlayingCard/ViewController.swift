//
//  ViewController.swift
//  PlayingCard
//
//  Created by Thara Nagaraj on 13/08/18.
//  Copyright © 2018 Thara Nagaraj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    @IBOutlet private var cardViews : [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    private var faceUpCardViews : [PlayingCardView]{
        return cardViews.filter{$0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
            && $0.alpha == 1
        }
    }
    
    
    private var faceUpCardViewsMatch : Bool{
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    
    
    @IBOutlet weak var playingCardView: PlayingCardView!{
        didSet{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
            playingCardView.addGestureRecognizer(pinch)
        }
    }
    
    var lastChoseCardView: PlayingCardView?
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        switch sender.state{
        case .ended:
            if let chosenCardView = sender.view as? PlayingCardView, faceUpCardViews.count < 2{
                lastChoseCardView = chosenCardView
//                cardBehavior.removeItem(chosenCardView)
                UIView.transition(with: chosenCardView,
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                                    // OR playingCardView.isFaceUp = !playingCardView.isFaceUp
                },
                                  completion: { finished in
                                    let cardsToAnimate = self.faceUpCardViews
                                    if self.faceUpCardViewsMatch{
                                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.7,
                                                                                       delay: 0,
                                                                                       options: [] ,
                                                                                       animations: { cardsToAnimate.forEach{
                                                                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                                                        }},
                                                                                       completion: { position in
                                                                                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75,
                                                                                                                                       delay: 0,
                                                                                                                                       options: [] ,
                                                                                                                                       animations: { cardsToAnimate.forEach{
                                                                                                                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                                                                                                        $0.alpha = 0
                                                                                                                                        }},
                                                                                                                                       completion: { position in
                                                                                                                                        cardsToAnimate.forEach{
                                                                                                                                            $0.isHidden = true
                                                                                                                                            $0.alpha = 1
                                                                                                                                            $0.transform = .identity
                                                                                                                                        }
                                                                                                                                        
                                                                                        }
                                                                                        )
                                        }
                                        )
                                    } else if cardsToAnimate.count == 2{
                                        if chosenCardView == self.lastChoseCardView{
                                        cardsToAnimate.forEach { cardView in
                                            UIView.transition(with: cardView,
                                                              duration: 0.6,
                                                              options: [.transitionFlipFromLeft],
                                                              animations: {
                                                                cardView.isFaceUp = false
                                            } ,
                                                              completion : { finished in
                                                                self.cardBehavior.addItem(cardView)
                                            }
                                            )
                                        }
                                        }
                                    }
                                    else {
                                        if !chosenCardView.isFaceUp {
                                            self.cardBehavior.addItem(chosenCardView)
                                        }
                                    }
                }
                )
            }
        default:
            break
        }
    }
    
    @objc func nextCard(){
        if let card = deck.draw(){
            playingCardView.rank = card.rank.order!
            playingCardView.suit = card.suit.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2){
            let card = deck.draw()!
            cards += [card, card]
        }
        
        for cardView in cardViews{
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order!
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:))))
            cardBehavior.addItem(cardView)
            
        }
    }
    
    
}

