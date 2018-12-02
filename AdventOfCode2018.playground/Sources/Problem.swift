import Foundation

public class Problem<Input, Result: Equatable> {
    public enum TestResult: String {
        case passed = "✅"
        case failed = "❌"
        case skipped = "💤"
    }
    
    public typealias TestableFunc = (Input) -> Result
    
    public var skipTests = false
    
    fileprivate var testFunc: TestableFunc!
    
    public init(testFunc: @escaping TestableFunc) {
        self.testFunc = testFunc
    }
    
    public func test(input: Input, expected: Result) -> TestResult {
        if skipTests {
            return .skipped
        }
        
        if testFunc(input) == expected {
            return .passed
        }
        return .failed
    }
    
    public func run(input: Input) -> Result {
        return testFunc(input)
    }
}

extension Problem.TestResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        return rawValue
    }
}
