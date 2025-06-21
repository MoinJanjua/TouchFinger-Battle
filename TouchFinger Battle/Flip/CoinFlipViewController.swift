//
//  CoinFlipViewController.swift
//  TouchFinger Battle
//
//  Created by Moin Janjua on 09/02/2025.
//

import Foundation
import UIKit
import AVFoundation
import GameKit

class CoinFlipViewController: UIViewController , CAAnimationDelegate ,AVAudioPlayerDelegate {
    
    @IBOutlet weak var coinImg: UIImageView!
    @IBOutlet weak var flipCoinButton: UIButton!
   // @IBOutlet weak var Titlelb: UILabel!
    @IBOutlet weak var imagebgview: UIView!
    
    
    //let coinProvider = CoinSideProvider()
    
    let colourProvider = BackgroundColourProvider()
    
    var flipButtonSound = URL(fileURLWithPath: Bundle.main.path(forResource: "flipSound", ofType: "mp3")!)
    
   // var coinImageSound = URL(fileURLWithPath: Bundle.main.path(forResource: "tapSound", ofType: "mp3")!)
    
    
    var audioPlayerButton = AVAudioPlayer()
    
    var audioPlayerImage = AVAudioPlayer()
    
    var previousColour: UIColor?
    
    var isFromCountryList = String()
    
    var coinSides: [UIImage] = []
    
    var flipImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        flipImage = UIImage(named: "whitecoinside")!
        flipCoinButton.layer.cornerRadius = 20
        coinSides.append(UIImage(named: "head")!)
        coinSides.append(UIImage(named: "tail")!)
        audioPlayerButton = try! AVAudioPlayer(contentsOf: flipButtonSound)
        //audioPlayerImage = try! AVAudioPlayer(contentsOf: coinImageSound)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        coinImg.isUserInteractionEnabled = true
        coinImg.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @IBAction func showCoinFlip(_ sender: UIButton) {
        sender.pulsate()
        flipCoinButton.isEnabled = false
        audioPlayerButton.play()
        
        var randomColour = colourProvider.randomColour()
        while previousColour == randomColour {
            randomColour = colourProvider.randomColour()
        }
        
        previousColour = randomColour
        coinImg.image = flipImage
        audioPlayerButton.delegate = self
        rotateCoin()
        
    }
    
    func rotateCoin() {
        let rotateAnimation = CABasicAnimation()
        rotateAnimation.keyPath = "transform.rotation"
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = 4 * Double.pi
        rotateAnimation.duration = 1.0
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.delegate = self
        
        coinImg.layer.add(rotateAnimation,
                          forKey: nil)
    }
    
    func animationDidStop(_ anim: CABasicAnimation, finished flag: Bool) {
        coinImg.layer.removeFromSuperlayer()
    }
    
    
    
    func randomCoinSide() -> UIImage {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: coinSides.count)
        return coinSides[randomNumber]
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        coinImg.image = randomCoinSide()
        if coinImg.image == UIImage(named: "head")
        {
            saveWinnerRecord(gameType: "CoinFLip", winnerColor: "", Name: "head")
        }
        else
        {
            saveWinnerRecord(gameType: "CoinFLip", winnerColor: "", Name: "tail")
        }
        flipCoinButton.isEnabled = true
    }
    
    
    func saveWinnerRecord(gameType: String, winnerColor: String, Name:String) {
        

        
        let timestamp = getCurrentDateTime() // Get current date & time

        let newRecord = recordsList(FlipName: gameType, date: timestamp, WinnerName: Name, colourName: "")

        // Retrieve previous records
        var previousRecords: [recordsList] = []
        if let savedData = UserDefaults.standard.data(forKey: "winners"),
           let decodedRecords = try? JSONDecoder().decode([recordsList].self, from: savedData) {
            previousRecords = decodedRecords
        }

        // Append new record
        previousRecords.append(newRecord)

        // Save updated records list
        if let encodedData = try? JSONEncoder().encode(previousRecords) {
            UserDefaults.standard.set(encodedData, forKey: "winners")
        }
    }

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        audioPlayerImage.play()
        
        audioPlayerImage.delegate = self
        
        _ = tapGestureRecognizer.view as! UIImageView
        
        // This is the bounce down animation.
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
            
            // This code sets the scale of the view to 70%.
            self.coinImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: nil)
        
        // This is the bounce up animation, runs at the same time as bounce down.
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
            
            // This code sets the scale of the view to 100%.
            self.coinImg.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
