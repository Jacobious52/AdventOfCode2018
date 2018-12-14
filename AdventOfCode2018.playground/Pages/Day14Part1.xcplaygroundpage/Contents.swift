//: [Previous](@previous)

import Foundation

//: ## Day 14 Part 1

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

let problem = Problem { (input: Int) -> String in
    
    var elfs = [0, 1]
    var scores = [3, 7]
    //printRepr(scores: scores, elfs: elfs)
    while scores.count < input + 10 {
        let sum = elfs.reduce(0) { $0 + scores[$1] }
        let (tens, ones) = sum.quotientAndRemainder(dividingBy: 10)
        if tens > 0 {
            scores.append(tens)
        }
        scores.append(ones)
        elfs = elfs.map { (1 + scores[$0] + $0) % scores.count }
        //printRepr(scores: scores, elfs: elfs)
    }
    
    return scores[input..<input+10].map(String.init).joined()
}
//: ### Tests

print(problem.test(input: 9, expected: "5158916779"))
print(problem.test(input: 5, expected: "0124515891"))
print(problem.test(input: 18, expected: "9251071085"))
print(problem.test(input: 2018, expected: "5941429882"))

//: ### Find Solution

print(problem.run(input: 165061))

//: [Next](@next)
