//: [Previous](@previous)

import Foundation

//: ## Day 14 Part 2

//: ### Problem definition

enum Tile: String {
    case empty = "."
    case wall = "#"
}

extension Tile: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}

typealias Map = [[Tile]]

func parseMap(string: String) throws -> (Map, [Unit]) {
    let lines = string.lines
    var map: Map = Array(repeating: Array(repeating: Tile.empty, count: lines.first!.count), count: lines.count)
    var entities: [Unit] = []
    
    for line in lines.enumerated() {
        for col in line.element.enumerated() {
            switch col.element {
            case ".":
                map[line.offset][col.offset] = .empty
            case "#":
                map[line.offset][col.offset] = .wall
            case "G":
                entities.append(Unit.goblin(row: line.offset, col: col.offset))
                map[line.offset][col.offset] = .empty
            case "E":
                entities.append(Unit.elf(row: line.offset, col: col.offset))
                map[line.offset][col.offset] = .empty
            default:
                throw "unknown element \(col.element)"
            }
        }
    }
    
    return (map, entities)
}

func print(map: Map, units: [Unit], marked: [Point] = [], mark: String = "") {
    for row in map.enumerated() {
        for col in row.element.enumerated() {
            if let entity = units.first(where: { $0.pos == Point(x: row.offset, y: col.offset) }) {
                print(entity, separator: "", terminator: "")
                continue
            }
            if marked.contains(Point(x: row.offset, y: col.offset)) {
                print(mark, separator: "", terminator: "")
                continue
            }
            print(map[row.offset][col.offset], separator: "", terminator: "")
        }
        print()
    }
    print()
}

extension Point {
    func adjacent4() -> [Point] {
        return [
            Point(x: x, y: y - 1),
            Point(x: x, y: y + 1),
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
        ]
    }
    
    func inside(left: Int = 0, top: Int = 0, width: Int, height: Int) -> Bool {
        return x >= left && x < width && y >= top && y < height
    }
    
    static func readingOrder(a: Point, b: Point) -> Bool {
        if a.x == b.x {
            return a.y < b.y
        }
        return a.x < b.x
    }
}

class Unit {
    var pos: Point
    
    var row: Int {
        return pos.x
    }
    
    var col: Int {
        return pos.y
    }
    
    enum Race: String {
        case goblin = "G"
        case elf = "E"
    }
    
    var race: Race
    
    var attackPower = 3
    var health = 200
    
    var isAlive: Bool {
        return health > 0
    }
    
    class func goblin(row: Int, col: Int) -> Unit {
        return Unit(race: .goblin, row: row, col: col)
    }
    
    class func elf(row: Int, col: Int) -> Unit {
        return Unit(race: .elf, row: row, col: col)
    }
    
    class func readingOrder(a: Unit, b: Unit) -> Bool {
        return Point.readingOrder(a: a.pos, b: b.pos)
    }
    
    //    class func findAlive(at: Point, units: [Unit]) -> Unit? {
    //        return units.first(where: { $0.isAlive && $0.pos == at })
    //    }
    
    init(race: Race, row: Int, col: Int) {
        self.pos = Point(x: row, y: col)
        self.race = race
    }
    
    func takeTurn(map: inout Map, units: inout [Unit]) {
        //print("turn", race)
        
        if !isAlive {
            return
        }
        
        var targets = units.filter({$0.isAlive && $0.race != self.race})
        if targets.isEmpty { return }
        
        var unitLookup: [Point:Unit] = units.reduce(into: [:]) { $0[$1.pos] = $1 }
        
        if attack(map: &map, targets: &targets, unitLookup: &unitLookup) {
            return
        }
        
        if move(map: &map, targets: &targets, unitLookup: &unitLookup) {
            attack(map: &map, targets: &targets, unitLookup: &unitLookup)
        }
    }
    
    @discardableResult func attack(map: inout Map, targets: inout [Unit], unitLookup: inout [Point:Unit]) -> Bool {
        let inRange = pos.adjacent4().filter { (p) -> Bool in
            if !p.inside(width: map.count, height: map.first!.count) {
                return false
            }
            if let unit = unitLookup[p] {
                if targets.contains(where: { $0.pos == unit.pos }) {
                    return true
                }
            }
            return false
        }
        
        if inRange.isEmpty {
            return false
        }
        
        // attack
        let preference = inRange.compactMap { unitLookup[$0] }.sorted { (a, b) -> Bool in
            if a.health == b.health {
                return Point.readingOrder(a: a.pos, b: b.pos)
            }
            return a.health < b.health
        }
        
        //debugPrint("adj", preference.first!)
        preference.first?.health -= attackPower
        
        return true
    }
    
    @discardableResult func move(map: inout Map, targets: inout [Unit], unitLookup: inout [Point:Unit]) -> Bool {
        let adjTargets = targets.reduce(into: [Point]()) { (points, target) in
            let open = target.pos.adjacent4().filter { (p) -> Bool in
                if !p.inside(width: map.count, height: map.first!.count) {
                    return false
                }
                if map[p.x][p.y] == .wall {
                    return false
                }
                return true
            }
            points.append(contentsOf: open)
        }
        
        if adjTargets.isEmpty {
            return false
        }
        
        //print(map: map, units: allUnits, marked: adjTargets, mark: "?")
        
        // dka
        var fringe: [Point] = [pos]
        var visited: Set<Point> = []
        var distances: [Point:Int] = [:]
        var paths: [Point:Point] = [:]
        
        while !fringe.isEmpty {
            let current = fringe.removeFirst()
            visited.insert(current)
            
            if targets.allSatisfy({ visited.contains($0.pos) }) {
                break
            }
            
            for next in current.adjacent4().sorted(by: Point.readingOrder).reversed()
                where next.inside(width: map.count, height: map.first!.count) &&
                    !visited.contains(next) &&
                    map[next.x][next.y] == .empty &&
                    unitLookup[next] == nil {
                        
                        distances[next] = distances[current, default: 0] + 1
                        paths[next] = current
                        fringe.append(next)
            }
        }
        //print(paths)
        
        let reachable = adjTargets.filter { visited.contains($0) }
        //print(map: map, units: allUnits, marked: reachable, mark: "@")
        
        if reachable.isEmpty {
            return false
        }
        
        let minDist = reachable.compactMap({distances[$0]}).min()!
        let minSteps = reachable.filter { distances[$0] == minDist }
        //print(map: map, units: allUnits, marked: minSteps, mark: "!")
        
        guard let closest = minSteps.sorted(by: Point.readingOrder).first else {
            return false
        }
        
        //print(map: map, units: allUnits, marked: [closest], mark: "+")
        // move 1 step
        
        var back = closest
        while paths[back]! != pos {
            back = paths[back]!
        }
        
        pos = back
        
        return true
    }
}

extension Unit: CustomStringConvertible {
    var description: String {
        return race.rawValue
    }
}

extension Unit: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(race.rawValue)(\(health)) - \(pos)"
    }
}

let problem = Problem { (map: Map, units: [Unit]) -> Int in
    var map = map
    var units = units
    
    // rounds
    var round = 0
    while true {
        units.sort(by: Unit.readingOrder)
        units.forEach { $0.takeTurn(map: &map, units: &units) }
        units = units.filter { $0.isAlive }
        //print(map: map, units: units)
        
        if units.allSatisfy({$0.race == .goblin}) {
            print("goblins win")
            break
        }
        if units.allSatisfy({$0.race == .elf}) {
            print("elfs win")
            break
        }
        
        //        if round % 10 == 0 {
        //            print(map: map, units: units)
        //        }
        
        round += 1
    }
    print(round, units.reduce(0) { $0 + $1.health })
    return round * units.reduce(0) { $0 + $1.health }
}

//: ### Tests

//let exampleInput = """
//#######
//#.G...#
//#...EG#
//#.#.#G#
//#..G#E#
//#.....#
//#######
//"""
//let (exampleMap, exampleUnits) = try parseMap(string: exampleInput)
//print(map: exampleMap, units: exampleUnits)
//print(problem.test(input: (exampleMap, exampleUnits), expected: 27730))

let a = try parseMap(string: """
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
""")
print(problem.test(input: a, expected: 27730))

let b = try parseMap(string: """
#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######
""")
print(problem.test(input: b, expected: 36334))

let c = try parseMap(string: """
#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######
""")
print(problem.test(input: c, expected: 39514))

let d = try parseMap(string: """
#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######
""")
print(problem.test(input: d, expected: 27755))

let e = try parseMap(string: """
#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######
""")
print(problem.test(input: e, expected: 28944))

let f = try parseMap(string: """
#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########
""")
print(problem.test(input: f, expected: 18740))


//: ### Find Solution

let inputString = try getInputString()
let input = try parseMap(string: inputString)
print(problem.run(input: input))

//: [Next](@next)
