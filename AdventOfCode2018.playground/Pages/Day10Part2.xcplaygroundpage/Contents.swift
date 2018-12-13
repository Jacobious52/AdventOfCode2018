//: [Previous](@previous)

import Foundation

//: ## Day 10 Part 2

//: ### Problem definition

extension Point {
    public func area(from: Point) -> Int {
        return abs(from.x - x) * abs(from.y - y)
    }
}

func parse(input: String) -> (pos: Point, vel: Point) {
    let signedIntegers = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "-")).inverted
    let nums = input.components(separatedBy: signedIntegers)
        .filter({$0 != ""})
        .compactMap(Int.init)
    return (Point(x: nums[0], y: nums[1]), Point(x: nums[2], y: nums[3]))
}

let problem = Problem { (points: [(pos: Point, vel: Point)]) -> String in
    var moved = points
    
    var minArea: Int?
    var minAreaPoints: [(pos: Point, vel: Point)]!
    var minHRange: ClosedRange<Int>!
    var minVRange: ClosedRange<Int>!
    
    var count = 0
    repeat {
        let leftBounds = moved.min(by: {$0.pos.x < $1.pos.x})!.pos.x
        let rightBounds = moved.max(by: {$0.pos.x < $1.pos.x})!.pos.x
        let topBounds = moved.min(by: {$0.pos.y < $1.pos.y})!.pos.y
        let bottomBounds = moved.max(by: {$0.pos.y < $1.pos.y})!.pos.y
        
        
        let boundsArea = Point(x: leftBounds, y: topBounds).area(from: Point(x: rightBounds, y: bottomBounds))
        if minArea == nil || boundsArea < minArea! {
            minArea = boundsArea
            minAreaPoints = moved
            minHRange = (leftBounds...rightBounds)
            minVRange = (topBounds...bottomBounds)
        } else {
            break
        }
        
        moved = moved.map({ (point) -> (pos: Point, vel: Point) in
            let (pos, vel) = point
            return (Point(x: pos.x + vel.x, y: pos.y + vel.y), vel)
        })
        count += 1
    } while true
    
    // print min
    print(count-1, "seconds")
    for y in minVRange {
        for x in minHRange {
            if minAreaPoints.contains(where: { $0.pos == Point(x: x, y: y) }) {
                print("#", separator: "", terminator: "")
                continue
            }
            print(".", separator: "", terminator: "")
        }
        print("")
    }
    
    return ""
}

//: ### Tests

let exampleInput = """
position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>
"""

problem.skipTests = true
let example = exampleInput.lines.map(parse)
print(problem.test(input: example, expected: "HI"))

//: ### Find Solution

let input = try getInputString().lines.map(parse)
print(problem.run(input: input))

//: [Next](@next)
