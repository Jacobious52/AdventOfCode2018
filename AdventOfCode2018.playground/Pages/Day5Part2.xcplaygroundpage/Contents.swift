//: [Previous](@previous)

import Foundation

//: # Advent of code 2018 playground
//: ## Day 5 Part 2

//: ### Problem definition

let problem = Problem { (polymer: [String]) -> Int in
    
    var counts: [Int] = []
    var allTypes: Set<String> = []
    polymer.forEach { allTypes.insert($0.uppercased()) }
    
    for toRemove in allTypes {
        let colapsed = polymer.reduce(into: [], { (units: inout [String], unit: String) in
            if unit.uppercased() == toRemove { return }
            
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
        
        counts.append(colapsed.count)
    }
    
   
    return counts.min()!
}

//: ### Tests


problem.test(input: ["d","a","b","A","c","C","a","C","B","A","c","C","c","a","D","A"], expected: 4)

//: ### Find Solution

let input = try getInputString().trimmingCharacters(in: .whitespacesAndNewlines).reduce(into: []) { $0.append(String($1)) }
problem.run(input: input)

//: [Next](@next)
