//
//  Helper.swift
//  ImageEditot
//
//  Created by Unique Consulting Firm on 24/04/2024.
//

import Foundation
import UIKit
import GameplayKit

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UILabel {

    @IBInspectable var borderWidth2: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius2: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor2: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

@IBDesignable extension UIView {

    @IBInspectable var borderWidth1: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius1: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor1: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

func roundCorner(button:UIButton)
{
    button.layer.cornerRadius = button.frame.size.height/2
    button.clipsToBounds = true
}

func roundCorner(view:UIView)
{
    view.layer.cornerRadius = view.frame.size.height/2
    view.clipsToBounds = true
}

func isFirstLaunch() -> Bool {
    let launchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    if !launchedBefore {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    }
    return !launchedBefore
}



func roundCornerimage(image:UIImageView)
{
    image.layer.cornerRadius = image.frame.size.height/2
    image.clipsToBounds = true
}

struct recordsList: Codable
{
    var FlipName: String
    var date: String
    var WinnerName: String
    var colourName: String
  }

var currency = ""

func formatAmount(_ amount: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    
    // Convert amount to a number
    if let number = formatter.number(from: amount) {
        return formatter.string(from: number) ?? amount
    } else {
        // If conversion fails, assume there's no dot and add two zeros after it
        let amountWithDot = amount + ".00"
        return formatter.string(from: formatter.number(from: amountWithDot)!) ?? amountWithDot
    }
}

extension UIViewController
{
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


struct BackgroundColourProvider {
    let colours = [
        UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0), // teal
        UIColor(red: 223/255.0, green: 86/255.0, blue: 94/255.0, alpha: 1.0), // red
        UIColor(red: 239/255.0, green: 130/255.0, blue: 100/255.0, alpha: 1.0), // orange
        UIColor(red: 77/255.0, green: 75/255.0, blue: 82/255.0, alpha: 1.0), // dark
        UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0), // purple
        UIColor(red: 85/255.0, green: 176/255.0, blue: 112/255.0, alpha: 1.0), // green
        UIColor(red: 128/255.0, green: 132/255.0, blue: 43/255.0, alpha: 1.0), // olive
        UIColor(red: 255/255.0, green: 215/255.0, blue: 165/255.0, alpha: 1.0), // nude
        UIColor(red: 152/255.0, green: 242/255.0, blue: 204/255.0, alpha: 1.0), // mint green
        UIColor(red: 255/255.0, green: 141/255.0, blue: 158/255.0, alpha: 1.0), // pink
        UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), // white
        UIColor(red: 255/255.0, green: 223/255.0, blue: 186/255.0, alpha: 1.0), // peach
        UIColor(red: 204/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0), // lavender
        UIColor(red: 255/255.0, green: 255/255.0, blue: 204/255.0, alpha: 1.0), // light yellow
        UIColor(red: 230/255.0, green: 230/255.0, blue: 250/255.0, alpha: 1.0), // light purple
        UIColor(red: 173/255.0, green: 216/255.0, blue: 230/255.0, alpha: 1.0), // light blue
        UIColor(red: 144/255.0, green: 238/255.0, blue: 144/255.0, alpha: 1.0), // light green
        UIColor(red: 255/255.0, green: 182/255.0, blue: 193/255.0, alpha: 1.0), // light pink
        UIColor(red: 240/255.0, green: 230/255.0, blue: 140/255.0, alpha: 1.0), // khaki
        UIColor(red: 245/255.0, green: 222/255.0, blue: 179/255.0, alpha: 1.0), // wheat
    ]
    
    func randomColour() -> UIColor {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: colours.count)
        return colours[randomNumber]
    }
}

func getCurrentDateTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: Date())
}

extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1.0
        pulse.fromValue = 0.94
        pulse.toValue = 1
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 5
        pulse.damping = 0.4
        
        layer.add(pulse, forKey: "pulse")
    }
}
