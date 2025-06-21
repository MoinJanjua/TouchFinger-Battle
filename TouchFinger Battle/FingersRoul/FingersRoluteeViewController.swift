//
//  FingersRoluteeViewController.swift
//  TouchFinger Battle
//
//  Created by Moin Janjua on 09/02/2025.
//

import UIKit

class FingersRoluteeViewController: UIViewController {

    var touchViews: [UITouch: UIView] = [:]
    var activeFingers: [UIView] = []
    var maxPlayers: Int = 6
    var timer: Timer?
    let circleSize: CGFloat = 150
    var records_List = [recordsList]()
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameView.isMultipleTouchEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.askForPlayerCount()
        }
        
        if isFirstLaunch() {
               showTutorialOverlay()
           }
        
        self.view.addSubview(contentView)
        self.contentView.addSubview(gameView)
    }
    
    
    func showTutorialOverlay() {
        let overlay = UIView(frame: self.view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        let instructionLabel = UILabel()
        instructionLabel.text = "Touch to play! Keep your fingers on the screen, and let the challenge begin!"
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        let gotItButton = UIButton()
        gotItButton.setTitle("Let's Start!", for: .normal)
        gotItButton.backgroundColor = .systemBlue
        gotItButton.setTitleColor(.white, for: .normal)
        gotItButton.layer.cornerRadius = 12
        gotItButton.addTarget(self, action: #selector(dismissTutorialOverlay(_:)), for: .touchUpInside)

        // Auto Layout Constraints
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        gotItButton.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(instructionLabel)
        overlay.addSubview(gotItButton)

        NSLayoutConstraint.activate([
            instructionLabel.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 120),
            instructionLabel.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 30),
            instructionLabel.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -30),
            
            gotItButton.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            gotItButton.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -100),
            gotItButton.widthAnchor.constraint(equalToConstant: 180),
            gotItButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        self.view.addSubview(overlay)
    }

    @objc func dismissTutorialOverlay(_ sender: UIButton) {
        sender.superview?.removeFromSuperview()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if activeFingers.count >= maxPlayers { return }

            let touchPoint = touch.location(in: gameView) // Ensure it's in gameView

            if touchViews[touch] == nil {
                let imageView = createImageView(at: touchPoint)
                gameView.addSubview(imageView) // Make sure it's added to gameView
                touchViews[touch] = imageView
                activeFingers.append(imageView)
            }
        }

        checkAndStartElimination()
    }

    func checkAndStartElimination() {
        if activeFingers.count == maxPlayers {
            startElimination()
        }
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let circleView = touchViews[touch] {
                circleView.center = touch.location(in: self.gameView)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let circleView = touchViews[touch] {
                circleView.removeFromSuperview()
                touchViews.removeValue(forKey: touch)
                activeFingers.removeAll { $0 == circleView }
            }
        }

        checkAndStartElimination()
    }


    func createCircle(at point: CGPoint, color: UIColor) -> UIView {
        //let circleSize: CGFloat = 80
        let circleView = UIView(frame: CGRect(x: point.x - circleSize / 2, y: point.y - circleSize / 2, width: circleSize, height: circleSize))
        circleView.backgroundColor = color
        circleView.layer.cornerRadius = circleSize / 2
        circleView.clipsToBounds = true
        return circleView
    }

    func randomColor() -> UIColor {
        let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange, .cyan, .magenta]
        return colors[activeFingers.count % colors.count]
    }

    func startElimination() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(eliminateOnePlayer), userInfo: nil, repeats: true)
    }

    @objc func eliminateOnePlayer() {
        if activeFingers.count <= 1 {
            timer?.invalidate()
            declareWinner()
            return
        }

        if let eliminatedFinger = activeFingers.randomElement() {
            activeFingers.removeAll { $0 == eliminatedFinger }

            UIView.animate(withDuration: 0.8, animations: {
                eliminatedFinger.alpha = 0
            }) { _ in
                eliminatedFinger.removeFromSuperview()
            }
        }
    }

    func declareWinner() {
        if let winner = activeFingers.first as? UIImageView, let winnerImage = winner.image {
            gameView.backgroundColor = UIColor.clear // اب بیک گراؤنڈ کلر سیٹ کرنے کی ضرورت نہیں

            UIView.animate(withDuration: 0.8, animations: {
                winner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            })

            let imageName = getImageName(from: winnerImage) // امیج کا نام حاصل کریں
            saveWinnerRecord(gameType: "FingerRoulette", winnerImageName: imageName)
            showWinnerAlert()
        }
    }
    
    func getImageName(from image: UIImage) -> String {
        let imageMapping: [String] = ["green Emoji", "Smily Emoji", "Cool Emoji", "Orange Emoji", "Blue Emoji", "Panda", "Sad Emoji", "black Emoji"]
        
        for name in imageMapping {
            if let img = UIImage(named: name), img.pngData() == image.pngData() {
                return name // اگر امیج مل جائے تو اس کا نام ریٹرن کریں
            }
        }
        
        return "default" // اگر کوئی امیج میچ نہ کرے تو ڈیفالٹ ریٹرن کریں
    }


    
    func saveWinnerRecord(gameType: String, winnerImageName: String) {
        let timestamp = getCurrentDateTime() // کرنٹ ڈیٹ ٹائم لینا

        let newRecord = recordsList(FlipName: gameType, date: timestamp, WinnerName: winnerImageName, colourName: winnerImageName)

        // پچھلے ریکارڈز حاصل کرنا
        var previousRecords: [recordsList] = []
        if let savedData = UserDefaults.standard.data(forKey: "winners"),
           let decodedRecords = try? JSONDecoder().decode([recordsList].self, from: savedData) {
            previousRecords = decodedRecords
        }

        // نیا ریکارڈ شامل کرنا
        previousRecords.append(newRecord)

        // اپڈیٹ شدہ لسٹ محفوظ کرنا
        if let encodedData = try? JSONEncoder().encode(previousRecords) {
            UserDefaults.standard.set(encodedData, forKey: "winners")
        }
    }


    func getImageName(_ color: UIColor) -> String {
        let colorToImageMap: [UIColor: String] = [
            .systemTeal: "green Emoji",
            .systemIndigo: "Smily Emoji",
            .systemPink: "Cool Emoji",
            .systemBrown: "Orange Emoji",
            .systemGray: "Blue Emoji",
            .cyan: "Panda",
            .systemYellow: "Sad Emoji",
            .red: "black Emoji"
        ]
        return colorToImageMap[color] ?? "default" // اگر کلر میچ نہ ہو تو "default" امیج استعمال ہوگی
    }



    func showWinnerAlert() {
        let alert = UIAlertController(title: "We Have a Champion! 🏆",
                                      message: "The last player standing is the ultimate winner!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default))
        present(alert, animated: true)
    }


    func askForPlayerCount() {
        let alert = UIAlertController(title: "Select Number of Players",
                                      message: "Choose how many players will join the battle!",
                                      preferredStyle: .alert)

        for i in 2...7 {
            alert.addAction(UIAlertAction(title: "\(i) Players", style: .default, handler: { _ in
                self.maxPlayers = i
                self.resetGame()
            }))
        }

        present(alert, animated: true)
    }


    func resetGame() {
        activeFingers.forEach { $0.removeFromSuperview() }
        activeFingers.removeAll()
        touchViews.removeAll()
    }

    @IBAction func backbtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    func randomImage() -> UIImage? {
        let imageNames = ["green Emoji", "Smily Emoji", "Cool Emoji", "Orange Emoji", "Blue Emoji", "Panda", "Sad Emoji", "black Emoji"]
        guard let randomName = imageNames.randomElement() else { return nil }
        
        return UIImage(named: randomName) ?? UIImage(named: "roul") // Ensuring an image always loads
    }
    
    func createImageView(at point: CGPoint) -> UIImageView {
        let imageSize: CGFloat = 100
        let imageView = UIImageView(frame: CGRect(x: point.x - imageSize / 2, y: point.y - imageSize / 2, width: imageSize, height: imageSize))
        
        imageView.image = randomImage() // Set a random image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageSize / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false // Ensuring it doesn't block touches

        return imageView
    }

}
