//: [Previous](@previous)
//: # Advent of code 2018 playground
//: ## Day 1 Part 1

import Foundation

//: ### Problem definition

let problem = Problem { (numbers: [Int]) -> Int in
    numbers.reduce(0) { x, y in
        x + y
    }
}

//: ### Tests

problem.test(input: [+1, -1], expected: 0)
problem.test(input: [+1, +1, +1], expected: 3)
problem.test(input: [-1, -2, -3], expected: -6)

//: ### Find Solution

let inputPath = Bundle.main.path(forResource: "input1", ofType: "txt")!
let numbers = try [Int].load(fromFile: inputPath)

problem.run(input: numbers)

//: [Next](@next)
