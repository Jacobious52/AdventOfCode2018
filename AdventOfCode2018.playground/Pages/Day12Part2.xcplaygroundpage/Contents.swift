//: [Previous](@previous)

import Foundation

//: ## Day 12 Part 2

//: ### Problem definition

enum Cell {
    case plant
    case empty
}

func readCell(_ string: String) -> Cell {
    if string == "#" { return .plant }
    return .empty
}

struct Mutation {
    var pattern: [Cell]
    var result: Cell
    
    init(pattern: [Cell], result: Cell) {
        self.pattern = pattern
        self.result = result
    }
    
    init(string: String) {
        let comp = string.components(separatedBy: CharacterSet(charactersIn: ".#").inverted).filter({$0 != ""})
        self.pattern = comp.first!.map({readCell(String($0))})
        self.result = readCell(comp.last!)
    }
}

let problem = Problem { (inital: [Cell], mutations: [Mutation], generations: Int) -> Int in
    
    func score(cells: [Int: Cell]) -> Int {
        let ordered = cells.sorted(by: {$0.key < $1.key})
        let firstPlant = ordered.first(where: {$0.value == .plant })!
        let lastPlant = ordered.last(where: {$0.value == .plant })!
        
        return cells.lazy.filter({$0.key >= firstPlant.key && $0.key <= lastPlant.key}).reduce(0, { (result, cell) -> Int in
            if cell.value == .plant {
                return result + cell.key
            }
            return result
        })
    }
    
    var nextGeneration: [Int: Cell] = inital.enumerated().reduce(into: [:], { $0[$1.offset] = $1.element })
    var repeating: Int!
    var oldScore = score(cells: nextGeneration)
    let iterations = 200
    
    for _ in 0..<iterations {
        var cells = nextGeneration
        
        let newScore = score(cells: cells)
        repeating = newScore - oldScore
        oldScore = newScore
        
        let ordered = cells.sorted(by: {$0.key < $1.key})
        
        let firstPlant = ordered.first(where: {$0.value == .plant })!
        let lastPlant = ordered.last(where: {$0.value == .plant })!
        
        ordered.forEach {
            if $0.key < firstPlant.key || $0.key > lastPlant.key {
                nextGeneration.removeValue(forKey: $0.key)
            }
        }
        
        for index in (firstPlant.key-1...lastPlant.key+1) {
            let match = (-2...2).map({cells[index + $0, default: .empty]})
            
            var newCell: Cell?
            for mutation in mutations {
                if mutation.pattern.elementsEqual(match) {
                    newCell = mutation.result
                    break
                }
            }
            nextGeneration[index] = newCell ?? .empty
        }
    }
    
    return score(cells: nextGeneration) + (generations - iterations) * repeating
}

//: ### Tests

// no tests

//: ### Find Solution

let inital = """
###..###....####.###...#..#...##...#..#....#.##.##.#..#.#..##.#####..######....#....##..#...#...#.#
""".map({ readCell(String($0)) })

let mutations = """
..#.# => #
###.# => .
#.#.# => .
.#.#. => .
##... => #
...## => .
.##.# => .
.#... => #
####. => #
....# => .
.##.. => #
.#### => #
..### => .
.###. => #
##### => #
..#.. => #
#..#. => .
###.. => #
#..## => #
##.## => #
##..# => .
.#..# => #
#.#.. => #
#.### => #
#.##. => #
..... => .
.#.## => #
#...# => .
...#. => #
..##. => #
##.#. => #
#.... => .
""".lines.map(Mutation.init)

print(problem.run(input: (inital, mutations, 50000000000)))

//: [Next](@next)
