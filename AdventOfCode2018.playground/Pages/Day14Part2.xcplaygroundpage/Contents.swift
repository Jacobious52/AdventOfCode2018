//: [Previous](@previous)

import Foundation

//: ## Day 14 Part 2

//: ### Problem definition

func printRepr(scores: [Int], elfs: [Int]) {
    for (i, score) in scores.enumerated() {
        if elfs.first! == i {
            print("(\(score))", separator: "", terminator: "")
            continue
        }
        if elfs.last! == i {
            print("[\(score)]", separator: "", terminator: "")
            continue
        }
        print(" \(score) ", separator: "", terminator: "")
    }
    print()
}

let problem = Problem { (input: String) -> Int in
    
    var elfs = [0, 1]
    var scores = [3, 7]
    let pattern = input.compactMap { Int(String($0)) }
    //printRepr(scores: scores, elfs: elfs)
    while true {
        let sum = elfs.reduce(0) { $0 + scores[$1] }
        let (tens, ones) = sum.quotientAndRemainder(dividingBy: 10)
        if tens > 0 {
            scores.append(tens)
            if scores.count > input.count && scores[scores.count-input.count..<scores.count].elementsEqual(pattern) {
                return scores.count-input.count
            }
        }
        scores.append(ones)
        elfs = elfs.map { (1 + scores[$0] + $0) % scores.count }
        //printRepr(scores: scores, elfs: elfs)
        if scores.count > input.count && scores[scores.count-input.count..<scores.count].elementsEqual(pattern) {
            return scores.count-input.count
        }
    }
}
//: ### Tests

print(problem.test(input: "51589", expected: 9))
print(problem.test(input: "01245", expected: 5))
print(problem.test(input: "92510", expected: 18))
print(problem.test(input: "59414", expected: 2018))
print(problem.test(input: "79251", expected: 17))

//: ### Find Solution

print(problem.run(input: "165061"))

//: [Next](@next)
