//: [Previous](@previous)

import Foundation

//: ## Day 11 Part 2

//: ### Problem definition

struct Point3D: Equatable, Hashable {
    var pos: Point
    var size: Int
    
    init(x: Int, y: Int, z: Int) {
        self.pos = Point(x: x, y: y)
        self.size = z
    }
}

let problem = Problem { (serial: Int) -> Point3D in
    
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
    var maxSize = 0
    
    var dp: [Point3D:Int] = [:]
    
    for size in 1...points.count-1 {
        for x in 0..<points.count-size {
            for y in 0..<points.count-size {
                var sum = 0
                
                if let preC = dp[Point3D(x: x, y: y, z: size-1)] {
                    sum += preC
                    for i in 0...size {
                        sum += points[x+i][y+size]
                    }
                    for j in 0..<size {
                        sum += points[x+size][j+y]
                    }
                } else {
                    for i in 0...size {
                        for j in 0...size {
                            sum += points[x+i][y+j]
                        }
                    }
                }
                
                dp[Point3D(x: x, y: y, z: size)] = sum
                if sum > maxSum {
                    maxSum = sum
                    maxX = x
                    maxY = y
                    maxSize = size
                }
            }
        }
    }
    
    return Point3D(x: maxX+1, y: maxY+1, z: maxSize+1)
}

//: ### Tests

print(problem.test(input: 18, expected: Point3D(x: 90, y: 269, z: 16)))
print(problem.test(input: 42, expected: Point3D(x: 232, y: 251, z: 12)))

//: ### Find Solution

print(problem.run(input: 9221))

//: [Next](@next)
