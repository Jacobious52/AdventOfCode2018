import Foundation

extension String {
    public var lines: [String] {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
    }
}

extension Array where Element == Int {
    
    public static func load(fromString string: String) throws -> Array<Element> {
        return string.lines.compactMap { Int($0) }
    }
    
    public static func load(fromFile filePath: String) throws -> Array<Element> {
        let input = try String(contentsOfFile: filePath)
        return try load(fromString: input)
    }
}
