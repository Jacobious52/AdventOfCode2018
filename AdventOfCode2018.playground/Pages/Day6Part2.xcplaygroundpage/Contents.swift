//: [Previous](@previous)

import Foundation

//: ### Problem definition

//: ## Day 6 Part 2

func distSum(point: Point, points: [Point]) -> Int {
    let manhattan = points.map {
        abs($0.x - point.x) + abs($0.y - point.y)
    }
    
    return manhattan.reduce(0, +)
}

let problem = Problem { (input: ([Point], Int)) -> Int in
    
    let (points, safe) = input
    let leftBounds = ( points.min { $0.x < $1.x } )!.x
    let rightBounds = ( points.max { $0.x < $1.x } )!.x
    let topBounds = ( points.min { $0.y < $1.y } )!.y
    let bottomBounds = ( points.max { $0.y < $1.y } )!.y
    
    var grid: [Point: Int] = [:]
    
    for (i, p) in points.enumerated() {
        grid[p, default: -1] = i
    }
    
    for y in topBounds...bottomBounds {
        for x in leftBounds...rightBounds {
            let point = Point(x: x, y: y)
            grid[point, default: -1] = distSum(point: point, points: points)
        }
    }
    
    let finite = points.filter {
        let p = ($0.x, $0.y)
        switch p {
        case (leftBounds+1..<rightBounds, topBounds+1..<bottomBounds):
            return true
        default:
            return false
        }
    }
    
    let areas = finite.map { (point) -> Int in
        let matching = grid.values.filter {
            $0 < safe
        }
        return matching.count
    }
    
    return areas.max()!
}

let example = """
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
"""
let points = example.lines.map { Point(string: $0) }

//: ### Tests

problem.test(input: (points, 32), expected: 16)

//: ### Find Solution

let input = try getInputString().lines.map { Point(string: $0) }
problem.run(input: (input, 10000))

//: [Next](@next)
