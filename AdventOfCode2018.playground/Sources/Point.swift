import Foundation

public struct Point : Hashable {
    public let x: Int
    public let y: Int
    
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
    
    public var hashValue : Int {
        get {
            return x.hashValue &* 31 &+ y.hashValue
        }
    }
}

public func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
