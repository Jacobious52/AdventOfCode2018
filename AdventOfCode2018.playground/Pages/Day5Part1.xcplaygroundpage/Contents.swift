//: [Previous](@previous)

import Foundation

//: # Advent of code 2018 playground
//: ## Day 5 Part 1

//: ### Problem definition

let problem = Problem { (polymer: [String]) -> Int in
    let colapsed = polymer.reduce(into: [], { (units: inout [String], unit: String) in
        if let last = units.last {
            if last.caseInsensitiveCompare(unit) == .orderedSame {
                if (last == last.uppercased() && unit == unit.lowercased()) ||
                   (last == last.lowercased() && unit == unit.uppercased()) {
                    units.removeLast()
                    return
                }
            }
        }
        units.append(unit)
    })
    return colapsed.count
}

//: ### Tests

problem.test(input: ["a","A"], expected: 0)
problem.test(input: ["a","b","B","A"], expected: 0)
problem.test(input: ["a","b","A","B"], expected: 4)
problem.test(input: ["a","a","b","A","A","B"], expected: 6)
problem.test(input: ["d","a","b","A","c","C","a","C","B","A","c","C","c","a","D","A"], expected: 10)

//: ### Find Solution

let input = try getInputString().trimmingCharacters(in: .whitespacesAndNewlines).reduce(into: []) { $0.append(String($1)) }
problem.run(input: input)

//: [Next](@next)
