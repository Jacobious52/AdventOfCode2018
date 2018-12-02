import Foundation

extension String: Error {}

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

public func getInputPath() throws -> String {
    guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
        throw "input file not found"
    }
    return path
}

public func getInputString() throws -> String {
    let path = try getInputPath()
    return try String(contentsOfFile: path)
}
