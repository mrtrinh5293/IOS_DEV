//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Duc Dang on 6/8/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    //Keep track of card
    var card: Card?
    
    // parameter card: expecting to get and pass the Card information
    func configureCell(card: Card){
        
        // Keep track of the card this cell represent
        // self.card = var card: Card - card is the info passing thru the parameter
        self.card = card
        
        //Set the front image view to the image that represent the card
        frontImageView.image = UIImage(named: card.imageName)
        
        //Reset the state of the cell by checking the flipped status of the card and then showing the fornt or the back of imageView accordingly
        
        if card.isMatched == true{
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        } else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
//            return
        }
        
        if card.isFlipped == true {
            flipUp(speed: 0)
        }
        else {
            flipDown(speed: 0,  delay: 0)
        }
    }
    
    //Flip up animation
    func flipUp(speed:TimeInterval = 0.3){
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        //Set the status of the card
        card?.isFlipped = true
    }
    
    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            //Flipdown animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
        //Set the status of the card
        card?.isFlipped = false
    }
    
    func remove() {
        // Make the image views invisible
        // alpha = set opacity
        backImageView.alpha = 0
        
        // add animate for dissappear card
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil) //completion specify block of code to run
        
    }
    
    
}
