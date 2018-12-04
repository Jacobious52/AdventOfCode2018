//: [Previous](@previous)

import Foundation

//: # Advent of code 2018 playground
//: ## Day 4 Part 2

//: ### Problem definition

struct Record {
    var time: Date
    enum Action {
        case startShift(id: Int)
        case fallAsleep
        case wakeUp
    }
    var action: Action
}

func <(lhs: Record, rhs: Record) -> Bool {
    return lhs.time < rhs.time
}

let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd HH:mm"
let calandar = Calendar.current

func parseRecord(str: String) throws -> Record {
    let tokens = str.split { "[] #".contains($0) }
    let date = formatter.date(from: tokens[0...1].joined(separator: " "))!
    calandar.component(.minute, from: date)
    
    switch tokens[2] {
    case "Guard":
        return Record(time: date, action: .startShift(id: Int(tokens[3])!))
    case "wakes":
        return Record(time: date, action: .wakeUp)
    case "falls":
        return Record(time: date, action: .fallAsleep)
    default:
        throw "invalid record"
    }
}

let problem = Problem { (records: [Record]) -> Int in
    var sleepMap: [Int:[Int:Int]] = [:]
    
    let firstEvent = records.first!
    guard case let Record.Action.startShift(firstGuard) = firstEvent.action else {
        return -1
    }
    
    var currentGuard = firstGuard
    var i = 0
    while i < records.count {
        let record = records[i]
        i += 1
        switch record.action {
        case .startShift(let nextGuard):
            currentGuard = nextGuard
        case .fallAsleep:
            let wakeUpEvent = records[i]
            i += 1
            guard case Record.Action.wakeUp = wakeUpEvent.action else {
                print("doesn't work")
                return -1
            }
            //let difference = wakeUpEvent.time.timeIntervalSince(record.time)
            //sleepMap[currentGuard, default: []].append(Int(difference/60))
            let startMinute = calandar.component(.minute, from: record.time)
            let endMinute = calandar.component(.minute, from: wakeUpEvent.time)
            for m in (startMinute..<endMinute) {
                sleepMap[currentGuard, default: [:]][m, default: 0] += 1
            }
            
        default:
            print("shouldn't get here \(record.action)")
        }
    }
    
    var maxGuard = -1
    var mostFrequentMinute = -1
    var mostFrequentCount = -1
    for kv in sleepMap {
        let mostFrequent = kv.value.max { $0.value < $1.value }
        if mostFrequent!.value > mostFrequentCount {
            maxGuard = kv.key
            mostFrequentCount = mostFrequent!.value
            mostFrequentMinute = mostFrequent!.key
        }
    }
    
    return maxGuard * mostFrequentMinute
}

//: ### Tests

let example = """
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
"""


let exampleRecords = try example.lines.map(parseRecord).sorted(by: <)
problem.test(input: exampleRecords, expected: 4455)

//: ### Find Solution

let input = try getInputString()
let records = try input.lines.map(parseRecord).sorted(by: <)
problem.run(input: records)

//: [Next](@next)
