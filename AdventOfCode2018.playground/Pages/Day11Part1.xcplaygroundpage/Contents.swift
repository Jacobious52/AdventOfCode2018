//: [Previous](@previous)

import Foundation

//: ## Day 10 Part 1

//: ### Problem definition

let problem = Problem { (serial: Int) -> Point in
    
    var points = Array(repeating: Array(repeating: 0, count: 300), count: 300)
    for x in 1...points.count {
        for y in 1...points.count {
            let rackID = x + 10
            let powerLevel = ((rackID * y) + serial) * rackID
            
            let digits = String(powerLevel).compactMap ({ (c: Character) -> Int? in
                return Int(String(c))
            })
            
            var hundreds = 0
            if digits.count >= 3 {
                hundreds = digits[digits.count - 3]
            }
            points[x-1][y-1] = hundreds - 5
        }
    }
    
    var maxSum = Int.min
    var maxX = 0
    var maxY = 0
    
    for x in 1..<points.count-1 {
        for y in 1..<points.count-1 {
            var sum = 0
            for i in -1...1 {
                for j in -1...1 {
                    sum += points[x+i][y+j]
                }
            }
            if sum > maxSum {
                maxSum = sum
                maxX = x
                maxY = y
            }
        }
    }
    
    return Point(x: maxX, y: maxY)
}

//: ### Tests

print(problem.test(input: 18, expected: Point(x: 33, y: 45)))
print(problem.test(input: 42, expected: Point(x: 21, y: 61)))

//: ### Find Solution

print(problem.run(input: 9221))

//: [Next](@next)
