//: [Previous](@previous)
//: # Advent of code 2018 playground
//: ## Day 1 Part 2

import Foundation

//: ### Problem definition

func findRepeating(numbers: [Int], previous: inout Set<Int>, last: Int) -> Int {
    var next = last
    for f in numbers {
        next = next + f
        if !previous.insert(next).inserted {
            return next
        }
    }
    return findRepeating(numbers: numbers, previous: &previous, last: next)
}

let problem = Problem { (numbers: [Int]) -> Int in
    var previous: Set<Int> = [0]
    return findRepeating(numbers: numbers, previous: &previous, last: 0)
}

//: ### Tests

problem.test(input: [+1, -1], expected: 0)
problem.test(input: [+3, +3, +4, -2, -4], expected: 10)
problem.test(input: [-6, +3, +8, +5, -6], expected: 5)
problem.test(input: [+7, +7, -2, -7, -4], expected: 14)

//: ### Find Solution

let inputPath = Bundle.main.path(forResource: "input1", ofType: "txt")!
let numbers = try [Int].load(fromFile: inputPath)

problem.run(input: numbers)

//: [Next](@next)
