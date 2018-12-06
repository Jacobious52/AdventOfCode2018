//: [Previous](@previous)

import Foundation

//: # Advent of code 2018 playground
//: ## Day 3 Part 2

//: ### Problem definition

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

func fill(fabric: inout [Point:[Int]], claim: Claim) {
    for x in claim.top.x..<claim.top.x+claim.size.x {
        for y in claim.top.y..<claim.top.y+claim.size.y {
            fabric[Point(x: x, y: y), default: []].append(claim.id)
        }
    }
}

func printFabric(_ fabric: [Point:[Int]]) {
    for x in 0..<10 {
        for y in 0..<10 {
            let value = fabric[Point(x: x, y: y), default: []]
            print(value.count, separator: "", terminator: "")
        }
        print("")
    }
}

let problem = Problem { (claims: [Claim]) -> Int in
    var fabric: [Point:[Int]] = [:]
    
    for claim in claims {
        fill(fabric: &fabric, claim: claim)
    }
    
    var clashes: Set<Int> = []
    for point in fabric {
        if point.value.count > 1 {
            for claim in point.value {
                clashes.insert(claim)
            }
        }
    }
    
    for claim in claims {
        if !clashes.contains(claim.id) {
            return claim.id
        }
    }
    
    return -1
}

//: ### Tests

problem.skipTests = false

let example = """
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
"""

let claims = example.lines.map(parseClaim)
problem.test(input: claims, expected: 3)

//: ### Find Solution

let input = try getInputString().lines.map(parseClaim)
problem.run(input: input)

//: [Next](@next)
