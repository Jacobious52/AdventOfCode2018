//: [Previous](@previous)

import Foundation

//: # Advent of code 2018 playground
//: ## Day 3 Part 1

//: ### Problem definition

struct Point : Hashable {
    let x: Int
    let y: Int
    
    var hashValue : Int {
        get {
            return x.hashValue &* 31 &+ y.hashValue
        }
    }
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}


struct Claim {
    var id: Int
    var top: Point
    var size: Point
}

func parseClaim(_ claim: String) -> Claim {
    let spaced = claim.split(separator: " ")
    let id = Int(spaced[0].trimmingCharacters(in: ["#"]))!
    
    let xy = spaced[2].trimmingCharacters(in: [":"]).split(separator: ",")
    let x = Int(xy[0])!
    let y = Int(xy[1])!
    
    let wh = spaced[3].split(separator: "x")
    let w = Int(wh[0])!
    let h = Int(wh[1])!
    
    return Claim(id: id, top: Point(x: x, y: y), size: Point(x: w, y: h))
}

func fill(fabric: inout [Point:Int], claim: Claim) {
    for x in claim.top.x..<claim.top.x+claim.size.x {
        for y in claim.top.y..<claim.top.y+claim.size.y {
            fabric[Point(x: x, y: y), default: 0] += 1
        }
    }
}

func printFabric(_ fabric: [Point:Int]) {
    for x in 0..<10 {
        for y in 0..<10 {
            let value = fabric[Point(x: x, y: y), default: 0]
            print(value, separator: "", terminator: "")
        }
        print("")
    }
}

let problem = Problem { (claims: [Claim]) -> Int in
    var fabric: [Point:Int] = [:]
    
    for claim in claims {
        fill(fabric: &fabric, claim: claim)
    }
    
    var clashes = 0
    for point in fabric {
        if point.value > 1 {
            clashes += 1
        }
    }
    
    //printFabric(fabric)
    
    return clashes
}

//: ### Tests

problem.skipTests = true

let example = """
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
"""

let claims = example.lines.map(parseClaim)
problem.test(input: claims, expected: 4)

//: ### Find Solution

let input = try getInputString().lines.map(parseClaim)
problem.run(input: input)

//: [Next](@next)
