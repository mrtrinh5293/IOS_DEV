//
//  ViewController.swift
//  MatchApp
//
//  Created by Duc Dang on 6/8/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // UICollectionView asking the ViewController for how many items it want to display
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel() //declare a property
    var cardsArray = [Card]() // declare empty card array
    
    var timer:Timer?
    var milliseconds:Int = 30*1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundManger()
    
    var isPaused = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // cardsArray(property) keeping charge of all card objects from the model
        
        cardsArray = model.getCards()  // assign getCard() return to cardsArray
        
        //Set the view controller as the datasource and delegate of the collectionView
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Initializrr the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
        
        
    }
    
    //MARK: - Timer method
    
    @objc func timerFired() {
        
        // Decrease the counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reaches zero
        if milliseconds == 0{
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            checkForGameEnd()
        }
        
        //Check if the user has cleared all pairs
        
    }
    
    @IBAction func onPause(_ sender: UIButton) {
        self.timer?.invalidate()
        let alert = UIAlertController(title: "Succesful", message: "Successfully added!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "End Game", style: .default, handler: { _ in
            let uivc = self.storyboard!.instantiateViewController(withIdentifier: "NewGameScreen")
            self.navigationController?.pushViewController(uivc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
        }))
        present(alert, animated: true)
    }
    
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // return n# of card to display
        //        print(cardsArray.count , "hello")
        return cardsArray.count
    }
    
    // indexPath: tells exactly which cell in the collectionView, including: indexPath.row, .section
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get a cell
        // dequeueReusableCell -> create or reuse cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of itself base on the property of the card that it represents
        let cardCell = cell as? CardCollectionViewCell
        
        //Get the card from the card array
        let card = cardsArray[indexPath.row]
        
        //configuting the cell
        
        cardCell?.configureCell(card: card)
    }
    
    
    // this indexPath tell us what card is selected by the user
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // CHeck if there any time remaining. Dont let the user interact if the time is 0
        if milliseconds <= 0{
            return
        }
        
        // Get a reference to the cell that was tapped
        // using as? because it is posiblility to be nil
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        //Check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false{
            cell?.flipUp()
            
            soundPlayer.playSound(effect: .flip)
            
            // Check if this is the first card or the 2nd was flipped
            if firstFlippedCardIndex == nil {
                
                // this is the first card flipped over
                firstFlippedCardIndex = indexPath
            } else {
                
                // Run the comparison logic
                checkforMatch(indexPath)
            }
        }
    }
    // MARK: - Game Logic Method
    func checkforMatch(_ secondFlippedCardIndex: IndexPath) {
        
        //Get the 2 card objects for the 2 indices(chi? so^') and see if they match
        
        let cardOne = cardsArray[firstFlippedCardIndex!.row] // the row indicate which cell it is
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represent card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            soundPlayer.playSound(effect: .match)
            
            // Its a match
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Set the status and remove em
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            
        }
        else {
            
            soundPlayer.playSound(effect: .nomatch)
            // Its not a match
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
        }
        
        // Reset the first FlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        
        //Check if there any card is unmatched
        
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                // when unmatched card has found
                hasWon = false
                break
            }
        }
        if hasWon {
            
            // Used has won, show alert
            showAlert("Congratulation", "You've won!")
        } else {
            
            // User hasnt won yet, check if there any time left
            if milliseconds <= 0 {
                showAlert("Time's Up", "Better luck next time")
            }
        }
    }
    
    func showAlert(_ title: String,_ message:String) {
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add butotn for user to dismiss it
        //        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let tryAgainAction = UIAlertAction(title:"Try Again", style: .default, handler: {
            action -> Void in self.resetApp()
        })
        
        //        alert.addAction(okAction)
        alert.addAction(tryAgainAction)
        
        // show alert
        present(alert, animated: true ,completion: nil)
    }
    
    func resetApp() {
        cardsArray = [Card]()
        cardsArray = model.getCards()
        milliseconds = 30000
        soundPlayer.playSound(effect: .shuffle)
        timerLabel.textColor = UIColor.black
        collectionView.reloadData()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    
    
}

