//
//  WelcomeViewController.swift
//  TouchFinger Battle
//
//  Created by Moin Janjua on 09/02/2025.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var startbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundCorner(button: startbtn)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }

}
