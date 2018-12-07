//: [Previous](@previous)

import Foundation

//: ## Day 7 Part 1

//: ### Problem definition

typealias Graph = [String: [String]]

func buildGraph(contraints: [String]) -> Graph {
    var graph: Graph = [:]
    
    contraints.map ({ (contraint) -> (String, String) in
        let tokens = contraint.components(separatedBy: [" "])
        return (tokens[1], tokens[7])
    }).forEach { (verts) in
        let (from, to) = verts
        graph[from, default: []].append(to)
    }
    
    return graph
}

let problem = Problem { (graph: Graph) -> String in
    // topological sort
    var incomming = graph.flatMap({ $0.value }).reduce(into: [:]) { (f: inout [String:Int], s: String) in
        f[s, default: 0] += 1
    }
    var fringe = Array(graph.filter ({ !incomming.keys.contains($0.key) }).keys)
    var sorted: [String] = []
    
    while !fringe.isEmpty {
        fringe.sort()
        let current = fringe.removeFirst()
        sorted.append(current)
        
        guard let edges = graph[current] else {
            continue
        }

        for next in edges {
            incomming[next, default: 1] -= 1
            if incomming[next, default: 0] == 0 {
                fringe.append(next)
            }
        }
    }
    
    return sorted.joined()
}

//: ### Tests

let example = """
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
"""

let exampleGraph = buildGraph(contraints: example.lines)
problem.test(input: exampleGraph, expected: "CABDFE")

//: ### Find Solution

let input = try getInputString().lines
let graph = buildGraph(contraints: input)
print(problem.run(input: graph))

//: [Next](@next)
