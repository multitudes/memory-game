import Foundation

public struct Card: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func ==(lhs: Card, rhs: Card) -> Bool{
        return lhs.identifier == rhs.identifier
    }
    
    
    public var isFaceUp = false
    public var isMatched = false
    public var identifier: Int
    
    // this is purely internal implemantation and can be private
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int{
        identifierFactory += 1
        return identifierFactory
    }
    
    public init() {
        
        self.identifier = Card.getUniqueIdentifier()
        
    }
    
}

// example of extension.. should be in main file.. however since swift 4.2 this is not needed anymore because Int has a random method
//extension Int {
//    var arc4random: Int {
//        return Int(arc4random_uniform(UInt32(self)))
//    }
//}

