//: [Previous](@previous)

import Foundation

//: ## Day 7 Part 2

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
        if graph[to] == nil {
            graph[to] = []
        }
    }
    
    return graph
}

func timeToFinish(label: String, timeStep: Int) -> Int {
    let scalar = UnicodeScalar(label)!
    return Int(scalar.value - UnicodeScalar("A")!.value) + 1 + timeStep
}

func assignToWorker(label: String, workers: inout [String?]) -> Int? {
    for (i, x) in workers.enumerated() {
        if x == nil {
            workers[i] = label
            return i
        }
    }
    return nil
}

let problem = Problem { (graph: Graph, numWorkers: Int, timeStep: Int) -> Int in
    var incomming = graph.flatMap({ $0.value }).reduce(into: [:]) { (f: inout [String:Int], s: String) in
        f[s, default: 0] += 1
    }
    var fringe: [String] = []
    var done: [String] = []
    var workers: [String?] = Array(repeating: nil, count: numWorkers)
    var remainingTime: [String: Int] = [:]
    
    var time = 0
    repeat {
        for node in graph {
            if !done.contains(node.key) && !workers.contains(node.key) && incomming[node.key, default: 0] == 0 {
                fringe.append(node.key)
            }
        }
        fringe.sort()
        
        var added: [String] = []
        for next in fringe {
            if let i = workers.firstIndex(of: nil) {
                workers[i] = next
                added.append(next)
            }
        }
        fringe = fringe.filter { !added.contains($0) }
        
        for case let (index, label?) in workers.enumerated() {
            remainingTime[label, default: timeToFinish(label: label, timeStep: timeStep)] -= 1
            if remainingTime[label]! == 0 {
                done.append(label)
                workers[index] = nil
                for child in graph[label]! {
                    incomming[child, default: 1] -= 1
                }
            }
        }
        time += 1

    } while done.count < graph.count
    done
    return time
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
problem.test(input: (exampleGraph, 2, 0), expected: 15)

//: ### Find Solution

let input = try getInputString().lines
let graph = buildGraph(contraints: input)
problem.run(input: (graph, 5, 60))

//: [Next](@next)
