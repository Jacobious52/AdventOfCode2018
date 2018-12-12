//: [Previous](@previous)

import Foundation

//: ## Day 12 Part 1

//: ### Problem definition

struct Mutation {
    var pattern: [String]
    var result: String
    
    init(pattern: [String], result: String) {
        self.pattern = pattern
        self.result = result
    }
    
    init(string: String) {
        let comp = string.components(separatedBy: CharacterSet(charactersIn: ".#").inverted).filter({$0 != ""})
        self.pattern = comp.first!.map(String.init)
        self.result = comp.last!
    }
}

let problem = Problem { (inital: [String], mutations: [Mutation], generations: Int) -> Int in
    
    var nextGeneration: [Int: String] = inital.enumerated().reduce(into: [:], { $0[$1.offset] = $1.element })
    
    for _ in 0..<generations {
        var cells = nextGeneration
        
        let ordered = cells.sorted(by: {$0.key < $1.key})
        cells[ordered.first!.key - 1] = "."
        cells[ordered.last!.key + 1] = "."
        
        //print(g, ordered.map({$0.value}).joined().trimmingCharacters(in: CharacterSet(charactersIn: ".")))
        
        for cell in cells {
            let match = (-2...2).map({cells[cell.key + $0, default: "."]})
            
            var newCell: String?
            for mutation in mutations {
                if mutation.pattern.elementsEqual(match) {
                    newCell = mutation.result
                    break
                }
            }
            nextGeneration[cell.key] = newCell ?? "."
        }
    }
    
    let sum = nextGeneration.reduce(0, { (result, cell) -> Int in
        if cell.value == "#" {
            return result + cell.key
        }
        return result
    })
    
    return sum
}

//: ### Tests

let exampleInitial = """
#..#.#..##......###...###
""".map(String.init)

let exampleMutations = """
...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
""".lines.map(Mutation.init)

print(problem.test(input: (exampleInitial, exampleMutations, 20), expected: 325))


//: ### Find Solution

let inital = """
###..###....####.###...#..#...##...#..#....#.##.##.#..#.#..##.#####..######....#....##..#...#...#.#
""".map(String.init)

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

print(problem.run(input: (inital, mutations, 20)))

//: [Next](@next)
