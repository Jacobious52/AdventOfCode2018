//: [Previous](@previous)

import Foundation

//: # Advent of code 2018 playground
//: ## Day 2 Part 2

//: ### Problem definition

let problem = Problem { (ids: [String]) -> Int in
    var twos = 0
    var threes = 0
    
    for id in ids {
        var freq: [Character:Int] = [:]
        for c in id {
            freq[c, default: 0] += 1
        }
        
        for f in freq {
            if f.value == 2 {
                twos += 1
                break
            }
        }
        
        for f in freq {
            if f.value == 3 {
                threes += 1
                break
            }
        }
    }
    
    
    return twos * threes
}

//: ### Tests

problem.test(input: ["abcdef",
                     "bababc",
                     "abbcde",
                     "abcccd",
                     "aabcdd",
                     "abcdee",
                     "ababab"],
             expected: 12)

//: ### Find Solution

let ids = try getInputString().lines
problem.run(input: ids)

//: [Next](@next)
