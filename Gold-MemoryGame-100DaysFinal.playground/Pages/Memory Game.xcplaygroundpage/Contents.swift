
import PlaygroundSupport
import UIKit

// This extension allows to use the image() function to any string to get an image with alpha = 0 for use in the emitterCell creation
extension String {
    func image(with font: UIFont = UIFont.systemFont(ofSize: 8.0)) -> UIImage {
        let string = NSString(string: "\(self)")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        let size = string.size(withAttributes: attributes)
        
        return UIGraphicsImageRenderer(size: size).image { _ in
            string.draw(at: .zero, withAttributes: attributes)
        }
    }
}

class ViewController: UIViewController {
    
    // computed property. If there is only get I can omit it and it looks like this. ok to make public it is a set anyway
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    // private because it is intimately tied to our UI
    private lazy var game = MemoryGame(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // outlets are almost always private
    private var titleLabel: UILabel!
    private var flipCountLabel: UILabel!
    var card: UIButton!
    private var cardButtons = [UIButton]()
    var gameOverLabel: UILabel!
    
    //it is ok public get but we dont want external set!
    private(set) var flipCount = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
    private func updateFlipCountLabel(){
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)  ,
            .strokeColor : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)  , .font: UIFont.systemFont(ofSize: 24)]
        let attributedString = NSAttributedString(string: "flips : \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memory Game"

    }
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        let attributes: [NSAttributedString.Key : Any] = [ .foregroundColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)  , .font: UIFont.systemFont(ofSize: 44) ]
        let attributedString = NSAttributedString(string: "Memory Game", attributes: attributes)
        titleLabel.attributedText = attributedString
       
        flipCountLabel = UILabel()
        flipCountLabel.translatesAutoresizingMaskIntoConstraints = false
        flipCountLabel.textAlignment = .center
        
        updateFlipCountLabel()
        view.addSubview(titleLabel)
        view.addSubview(flipCountLabel)
      
       
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = .red
        buttonsView.layer.masksToBounds = true
        buttonsView.layer.cornerRadius = 9
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flipCountLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            flipCountLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            //card.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 360),
            buttonsView.heightAnchor.constraint(equalToConstant: 480),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //buttonsView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -60)
            ])
        let width = 120
        let height = 120
        
        // create 12 buttons as a 4x3 grid
        for row in 0..<4 {
            for col in 0..<3 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .roundedRect)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 54)
                letterButton.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                letterButton.layer.cornerRadius = 8
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width + 5 , y: row * height + 5, width: width - 10, height: height - 10)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                letterButton.addTarget(self, action: #selector(touchCard), for: .touchUpInside)
                // and also to our letterButtons array
                cardButtons.append(letterButton)
            }
        }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1 , delay: 0, options: [], animations: {
            self.cardButtons.forEach {
                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                }
        }) { (position) in
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
                self.cardButtons.forEach {
                    $0.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                }
            })
        }
        
    }
    
    func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 0) : #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
        }
    }

    private var faceUpViews: [Card] {
        return game.cards.filter { $0.isFaceUp }
    }
    
    private var emoji = [Card: String]()
    var emojiChoices = "🍪🐼🐯🐷🐸🐵🙈🙉🐒🦉🦄🐝🍉🍎🍌🥦🥑🛴🚀🚁🐋🍡🍮🍫🍯☕️"

    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomIndex = Int.random(in: 0 ..< emojiChoices.count)
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: randomIndex)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? ""
    }
    
    @objc private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            
            UIView.transition(with: sender, duration: 0.5, options: [.transitionFlipFromLeft], animations: {self.updateViewFromModel()}
            )
            // chacking if game is over
            if game.matches == cardButtons.count {
                let identifier = game.cards[cardNumber].identifier
                for cardID in cardButtons.indices {
                    if game.cards[cardID].identifier == identifier{
                        game.cards[cardID].isFaceUp = false
                    }
                }
                game.cards[cardNumber].isFaceUp = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.gameOver()
                }
                
            }
        } else {
            print("chosen card not in ")
        }
    }

    
    
    public func createEmojiEmitter(){
        
        // create the final emitter effect
        let emitterView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        
        let rect = CGRect(x: 0.0, y: 0.0,
                          width: emitterView.bounds.width, height: -100.0)
        
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        
        // Add the layer
        emitterView.layer.addSublayer(emitter)
        
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
        
        emitter.emitterPosition = CGPoint(x: rect.width/2,
                                          y: rect.height/2)
        emitter.emitterSize = rect.size
        
        let contents = emojiChoices.map {String($0)}
        emitter.emitterCells =  contents.map { content in
            let emitterCell = CAEmitterCell()
            
            //: give content to my emitter cell which will be equal to every single emoji in the array converted to image and then to cgImage
            emitterCell.contents = content.image().cgImage
            
            //: how many created per second
            emitterCell.birthRate = 1
            //: how long they will stay on screen
            emitterCell.lifetime = 6.5
            //: This will add a little acceleration in the y-direction
            emitterCell.yAcceleration = 70.0
            
            emitterCell.xAcceleration = 10.0
            //: the velocity parameter sets the initial speed of the particle
            emitterCell.velocity = 20.0
            //: add some randomness
            emitterCell.velocityRange = 200.0
            emitterCell.emissionLongitude = -.pi
            emitterCell.emissionRange = .pi * 0.5
            
            //: assigning a random size to each
            emitterCell.scale = 1
            emitterCell.scaleRange = 0.5
            //: modify the size of the emoji as it falls.  scale down/up their original size per second.
            emitterCell.scaleSpeed = 0.1
            
            return emitterCell
            
        }
        view.addSubview(emitterView)
    }
    
    public func gameOver() {
        print("game over")
        let gameOverLabel = UILabel()
        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
        gameOverLabel.backgroundColor = .yellow
        gameOverLabel.textAlignment = .center
        gameOverLabel.text = "Game Over"
        gameOverLabel.font = UIFont.systemFont(ofSize: 36)
        //When the value of this property is true, Core Animation creates an implicit clipping mask that matches the bounds of the layer and includes any corner radius effects. The default value of this property is false
        gameOverLabel.layer.masksToBounds = true
        gameOverLabel.layer.cornerRadius = 10
        view.addSubview(gameOverLabel)
        NSLayoutConstraint.activate([
            gameOverLabel.widthAnchor.constraint(equalToConstant: 300),
            gameOverLabel.heightAnchor.constraint(equalToConstant: 200),
            gameOverLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameOverLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        gameOverLabel.center.x += 350
                        gameOverLabel.frame.size.width = 200
        }, completion: { _ in
            self.createEmojiEmitter()
        })
        
    }

}

let gameView = ViewController()


PlaygroundPage.current.liveView = gameView










