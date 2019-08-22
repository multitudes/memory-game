//
//
//public func createEmojiEmitter(){
//    
//    // create the final emitter effect
//    let emitterView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
//    
//    let rect = CGRect(x: 0.0, y: 0.0,
//                      width: emitterView.bounds.width, height: -100.0)
//    
//    let emitter = CAEmitterLayer()
//    emitter.frame = rect
//    
//    // Add the layer
//    emitterView.layer.addSublayer(emitter)
//    
//    emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
//    
//    emitter.emitterPosition = CGPoint(x: rect.width/2,
//                                      y: rect.height/2)
//    emitter.emitterSize = rect.size
//    
//    let contents = emojiChoices.map {String($0)}
//    emitter.emitterCells =  contents.map { content in
//        let emitterCell = CAEmitterCell()
//        
//        //: give content to my emitter cell which will be equal to every single emoji in the array converted to image and then to cgImage
//        emitterCell.contents = content.image().cgImage
//        
//        //: how many created per second
//        emitterCell.birthRate = 1
//        //: how long they will stay on screen
//        emitterCell.lifetime = 6.5
//        //: This will add a little acceleration in the y-direction
//        emitterCell.yAcceleration = 70.0
//        
//        emitterCell.xAcceleration = 10.0
//        //: the velocity parameter sets the initial speed of the particle
//        emitterCell.velocity = 20.0
//        //: add some randomness
//        emitterCell.velocityRange = 200.0
//        emitterCell.emissionLongitude = -.pi
//        emitterCell.emissionRange = .pi * 0.5
//        
//        //: assigning a random size to each
//        emitterCell.scale = 1
//        emitterCell.scaleRange = 0.5
//        //: modify the size of the emoji as it falls.  scale down/up their original size per second.
//        emitterCell.scaleSpeed = 0.1
//        
//        return emitterCell
//        
//    }
//    view.addSubview(emitterView)
//}
//
//public func gameOver() {
//    print("game over")
//    let gameOverLabel = UILabel()
//    gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
//    gameOverLabel.backgroundColor = .yellow
//    gameOverLabel.textAlignment = .center
//    gameOverLabel.text = "Game Over"
//    gameOverLabel.font = UIFont.systemFont(ofSize: 36)
//    //When the value of this property is true, Core Animation creates an implicit clipping mask that matches the bounds of the layer and includes any corner radius effects. The default value of this property is false
//    gameOverLabel.layer.masksToBounds = true
//    gameOverLabel.layer.cornerRadius = 10
//    view.addSubview(gameOverLabel)
//    NSLayoutConstraint.activate([
//        gameOverLabel.widthAnchor.constraint(equalToConstant: 300),
//        gameOverLabel.heightAnchor.constraint(equalToConstant: 200),
//        gameOverLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        gameOverLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    
//    UIView.animate(withDuration: 3,
//                   delay: 0.5,
//                   options: .curveEaseOut,
//                   animations: {
//                    gameOverLabel.center.x += 100
//                    gameOverLabel.frame.size.width = 200
//    }, completion: { _ in
//        createEmojiEmitter()
//    })
//    
//    
//    
//    
//}
