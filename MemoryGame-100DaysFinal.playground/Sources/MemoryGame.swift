import Foundation

public struct MemoryGame {
    
    // has to be public otherwise th eUI cant display the cards. but really I need to stop others from setting the cards.. but in the playgrounds needs to be public!
    public var cards = [Card]()
    
    // computed property .  can be private
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
                
            }
        }
    }
    
    public var matches = 0
    
    public init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0 ,"Concentration.init(\(numberOfPairsOfCards)) : you must have at least one pair of cards")
        
        for _ in  1...numberOfPairsOfCards{
        let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
 
    // this is the motor of the game. Public access control
    public mutating func chooseCard(at index: Int){
        // lets play with assertions. index has to be in the arrayindices! otherwise crash. Asserts are not shipped to the app store..
        assert(cards.indices.contains(index),"Concentration.chooseCard(at index: \(index)) : choosen index not in cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if the cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matches += 2
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
                
            }
            
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
