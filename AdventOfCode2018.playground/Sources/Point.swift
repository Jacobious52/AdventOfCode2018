import Foundation

public struct Point : Hashable {
    public let x: Int
    public let y: Int
    
    public static let zero = Point()
    
    public init() {
        self.x = 0
        self.y = 0
    }
    
    public init(string: String) {
        let nums = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        self.x = Int(nums[0])!
        self.y = Int(nums[2])!
    }
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public var reversed: Point {
        return Point(x: y, y: x)
    }
}

extension Point: CustomStringConvertible {
    public var description: String {
        return "(\(x), \(y))"
    }
}

public func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func +(lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
