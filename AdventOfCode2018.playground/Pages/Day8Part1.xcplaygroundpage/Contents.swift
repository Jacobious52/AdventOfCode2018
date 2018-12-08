//: [Previous](@previous)

import Foundation

//: ## Day 8 Part 1

//: ### Problem definition

class Node {
    var children: [Node] = []
    var metadata: [Int] = []
}

func buildNode(input: inout [Int]) -> Node? {
    if input.isEmpty {
        return nil
    }
    
    let n = Node()
    let numChildren = input.removeFirst()
    let numMetadata = input.removeFirst()
    for _ in 0..<numChildren {
        if let child = buildNode(input: &input) {
            n.children.append(child)
        }
    }
    for _ in 0..<numMetadata {
        n.metadata.append(input.removeFirst())
    }
    
    return n
    
}

let problem = Problem { (tree: Node) -> Int in
    func sum(node: Node) -> Int {
        var total = 0
        for n in node.children {
            total += sum(node: n)
        }
        
        return total + node.metadata.reduce(0, +)
    }
    return sum(node: tree)
}

//: ### Tests

let example = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

var exampleInput = example.components(separatedBy: .whitespaces).compactMap(Int.init)
let exampleTree = buildNode(input: &exampleInput)!
print(problem.test(input: exampleTree, expected: 138))

//: ### Find Solution

var input = try getInputString().components(separatedBy: .whitespaces).compactMap(Int.init)
let tree = buildNode(input: &input)!
print(problem.run(input: tree))

//: [Next](@next)
