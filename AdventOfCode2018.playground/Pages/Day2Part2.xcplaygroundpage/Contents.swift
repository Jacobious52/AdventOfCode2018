//: [Previous](@previous)

import Foundation

//: # Advent of code 2018 playground
//: ## Day 1 Part 2

//: ### Problem definition

let problem = Problem { (ids: [String]) -> String in
    for i in 0..<ids.count {
        for j in i+1..<ids.count {
            var a = ids[i]
            let b = ids[j]
            var difference = 0
            var lastDifferenceIndex: String.Index!
            
            for k in 0..<a.count {
                let indexA = a.index(a.startIndex, offsetBy: k)
                let indexB = b.index(b.startIndex, offsetBy: k)
                if a[indexA] != b[indexB] {
                    difference += 1
                    lastDifferenceIndex = indexA
                }
            }
            
            if difference == 1 {
                a.remove(at: lastDifferenceIndex)
                return a
            }
        }
    }
    
    return "no difference of 1 found"
}

//: ### Tests

let example = """
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz
"""

problem.test(input: example.lines,
             expected: "fgij")

//: ### Find Solution

let ids = try getInputString().lines
problem.run(input: ids)

//: [Next](@next)
