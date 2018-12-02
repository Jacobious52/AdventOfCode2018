import Foundation

extension String {
    public var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

extension Array where Element == Int {
    public static func load(fromFile filePath: String) throws -> Array<Element> {
        let input = try String(contentsOfFile: filePath)
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).lines
        return lines.compactMap { Int($0) }
    }
}
