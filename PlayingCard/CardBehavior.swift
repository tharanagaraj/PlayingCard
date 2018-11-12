//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by Thara Nagaraj on 11/11/18.
//  Copyright © 2018 Thara Nagaraj. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }

    
    lazy var collisionBehavior : UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    private func pushBehavior(_ item: UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2 * CGFloat.pi).arc4random
        push.magnitude = CGFloat(1.0) + CGFloat(0.1).arc4random
        // unowned means it's not reference counted; weak is not stored in the heap
        // needs optional chaining now since it's optional
        push.action = {[unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item : UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        pushBehavior(item)
    }
    
    func removeItem(_ item : UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
}
