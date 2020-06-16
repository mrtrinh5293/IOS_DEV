//
//  CardModel.swift
//  MatchApp
//
//  Created by Duc Dang on 6/8/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import Foundation

class CardModel {
    func getCards() -> [Card] {
        
        // Declare an empty array to store numbers that we've generated
        var generatedNUmbers = [Int]()
        
        // Declare and empty array
        var generatedCards = [Card]()  // create new array object
        
        // generate a random number
        while generatedNUmbers.count < 8{
            //        for _ in 1...8{
            
            let randomNum = Int.random(in: 1...13)
            if generatedNUmbers.contains(randomNum) == false {
                
                
                // Create 2 new cards objects
                let cardOne = Card()
                cardOne.imageName = "card\(randomNum)"
                //            generatedCards.append(cardOne)
                
                
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNum)"
                //            generatedCards.append(cardTwo)
                
                // Add them to the array
                generatedCards += [cardOne, cardTwo]
                print(randomNum)
                
                //Add this number to the list of generatted numbers
                generatedNUmbers.append(randomNum)
            }
        }
        //Randomize the cards with  the array
        generatedCards.shuffle()
        
        // Return the array
        return generatedCards
        
    }
}
