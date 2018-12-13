//: [Previous](@previous)

import Foundation

//: ## Day 13 Part 2

//: ### Problem definition

func getExampleString() throws -> String {
    guard let path = Bundle.main.path(forResource: "example", ofType: "txt") else {
        throw "input file not found"
    }
    return try String(contentsOfFile: path)
}

func loadMap(input: String) -> [[Character]] {
    let lines = input.components(separatedBy: .newlines)
    var map = Array(repeating: Array(repeating: Character(" "), count: lines.max()!.count), count: lines.count)
    
    for line in lines.enumerated() {
        for char in line.element.enumerated() {
            map[line.offset][char.offset] = char.element
        }
    }
    
    return map
}

let upDown = "^v"
let leftRight = "><"
let cartSet = upDown + leftRight

class Cart: CustomStringConvertible {
    var pos: Point
    var char: Character
    var turns: Int
    
    init(pos: Point, char: Character, turns: Int) {
        self.pos = pos
        self.char = char
        self.turns = turns
    }
    
    var directionDelta: Point {
        switch char {
        case "<":
            return Point(x: 0, y: -1)
        case ">":
            return Point(x: 0, y: 1)
        case "^":
            return Point(x: -1, y: 0)
        case "v":
            return Point(x: 1, y: 0)
        default:
            return Point.zero
        }
    }
    
    func move(onMap map: [[Character]]) {
        let rail = map[pos.x][pos.y]
        
        func move(delta: Point) {
            pos = pos + delta
        }
        
        func turn(direction: Character) {
            char = direction
        }
        
        let leftTurns: [Character:Character] = [
            ">": "^",
            "^": "<",
            "<": "v",
            "v": ">",
        ]
        let rightTurns: [Character:Character] = [
            ">": "v",
            "^": ">",
            "<": "^",
            "v": "<",
        ]
        
        move(delta: directionDelta)
        
        let newRail = map[pos.x][pos.y]
        switch newRail {
        case "\\":
            if upDown.contains(char) {
                turn(direction: leftTurns[char]!)
            } else if leftRight.contains(char) {
                turn(direction: rightTurns[char]!)
            }
        case "/":
            if leftRight.contains(char) {
                turn(direction: leftTurns[char]!)
            } else if upDown.contains(char) {
                turn(direction: rightTurns[char]!)
            }
        case "+":
            if turns == 0 {
                turn(direction: leftTurns[char]!)
            } else if turns == 2 {
                turn(direction: rightTurns[char]!)
            }
            turns = (turns + 1) % 3
        default: break
        }
    }
    
    var description: String {
        return "{pos: \(pos), char: '\(char)', turn: \(turns)}"
    }
}

func printMap(_ map: [[Character]], _ carts: [Cart]) {
    for (i, x) in map.enumerated() {
        for (j, y) in x.enumerated() {
            if let cart = carts.first(where: {$0.pos == Point(x: i, y: j)}){
                print(cart.char, separator: "", terminator: "")
                continue
            }
            print(y, separator: "", terminator: "")
        }
        print()
    }
    print()
}

let problem = Problem { (map: [[Character]]) -> Point in
    var map = map
    
    // find carts and repair rails
    var carts: [Cart] = []
    for line in map.enumerated() {
        for char in line.element.enumerated() {
            if cartSet.contains(char.element) {
                carts.append(Cart(pos: Point(x: line.offset, y: char.offset), char: char.element, turns: 0))
                map[line.offset][char.offset] = upDown.contains(char.element) ? "|" : "-"
            }
        }
    }
    
    //printMap(map, carts)
    while true {
        carts.sort { (a, b) -> Bool in
            if a.pos.x == b.pos.x {
                return a.pos.y < b.pos.y
            }
            return a.pos.x < b.pos.x
        }
        
        var toRemove: [Cart] = []
        for cart in carts {
            cart.move(onMap: map)
            let crash = carts.first { (c) -> Bool in
                return c !== cart && c.pos == cart.pos
            }
            if let crash = crash {
                toRemove.append(contentsOf: [cart, crash])
            }
        }
        carts.removeAll(where: { c -> Bool in
            toRemove.contains {$0 === c }
        })
        
        if carts.count == 1 {
            return carts.first!.pos.reversed
        }
        //printMap(map, carts)
    }
}

//: ### Tests

let example = try loadMap(input: getExampleString())
print(problem.test(input: example, expected: Point(x: 6, y: 4)))

//: ### Find Solution

let path = try getInputPath()
let inputString = try String(contentsOfFile: path)

let input = loadMap(input: inputString)
print(problem.run(input: input))

//: [Next](@next)
