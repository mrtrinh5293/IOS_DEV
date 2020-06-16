//
//  SoundManager.swift
//  MatchApp
//
//  Created by Duc Dang on 6/11/20.
//  Copyright © 2020 Duc Dang. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManger {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
        
    }
    
    func playSound(effect: SoundEffect) {
        var soundFilename = ""
        
        switch effect {
            
            case .flip:
                soundFilename = "cardflip"
                
            case .match:
                soundFilename = "dingcorrect"
                
            case .nomatch:
                soundFilename = "dingwrong"
                
            case .shuffle:
                soundFilename = "shuflfe"
            //
            //        default:
            //            soundFilename = ""
        }
        
        // Sound path
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        // CHeck if it is not nil
        guard bundlePath != nil else {
            // Couldnt find the resource, exit
            return
        }
        // need url to actually demonstrate resource
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            // Play the sound effect
            audioPlayer?.play() 
        }
        catch {
             print("could not create audio player")
        }
    }
}
