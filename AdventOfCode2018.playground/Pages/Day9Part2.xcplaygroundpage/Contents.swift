//: [Previous](@previous)

import Foundation

//: ## Day 9 Part 2

//: ### Problem definition

class Node {
    var next: Node!
    var prev: Node!
    var element: Int!
}

func parse(_ input: String) -> (numPlayers: Int, numMarbles: Int) {
    let parts = input.components(separatedBy: CharacterSet.decimalDigits.inverted)
        .filter({$0 != ""})
        .compactMap(Int.init)
    return (parts.first!, parts.last! * 100)
}

// ringPrint prints a fully connected node ring in order from the starting point
// anyNode can be any node in the ring
// returns the node that contains startingFrom
// this should probably be 2 functions find and print :P
func ringPrint(startingFrom: Int, anyNode: Node) -> Node {
    var find = anyNode
    var next = anyNode
    repeat {
        if next.element == startingFrom {
            find = next
        }
        if find.element == startingFrom {
            print(next.element!, separator: "", terminator: ",")
        }
        next = next.next
    } while next !== find
    
    return find
}

let problem = Problem { (numPlayers: Int, numMarbles: Int) -> Int in
    
    var players: [Int:Int] = [:]
    var current = Node()
    current.next = current
    current.prev = current
    current.element = 0
    
    for i in 1...numMarbles {
        if i % 23 == 0 {
            players[i % numPlayers, default: 0] += i
            current = current.prev.prev.prev.prev.prev.prev!
            
            players[i % numPlayers, default: 0] += current.prev.element
            current.prev.prev.next = current
            current.prev = current.prev.prev
            
            continue
        }
        
        let next = Node()
        next.element = i
        next.next = current.next.next
        next.prev = current.next
        
        let old = current.next.next!
        current.next.next = next
        old.prev = next
        
        current = next
    }
    
    //ringPrint(startingFrom: 0, anyNode: current)
    
    return players.values.max()!
}

//: ### Tests

// no tests :(

//: ### Find Solution

// good luck running this one in playgrounds :P
let input = try getInputString()
print(problem.run(input: parse(input)))

//: [Next](@next)
