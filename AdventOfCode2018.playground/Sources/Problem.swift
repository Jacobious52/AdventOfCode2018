import Foundation

public class Problem<Input, Result: Equatable> {
    public enum TestResult {
        case passed(Result)
        case failed(Result)
        case skipped
    }
    
    public typealias TestableFunc = (Input) -> Result
    
    public var skipTests = false
    
    fileprivate var testFunc: TestableFunc!
    
    public init(testFunc: @escaping TestableFunc) {
        self.testFunc = testFunc
    }
    
    public func test(input: Input, expected: Result) -> TestResult {
        if skipTests { return .skipped }
        let result = testFunc(input)
        if result == expected { return .passed(result) }
        return .failed(result)
    }
    
    public func run(input: Input) -> Result {
        return testFunc(input)
    }
}

extension Problem.TestResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .passed(let result):
            return "✅ (\(result))"
        case .failed(let result):
            return "❌ (\(result))"
        case .skipped:
            return "💤"
        }
    }
}
