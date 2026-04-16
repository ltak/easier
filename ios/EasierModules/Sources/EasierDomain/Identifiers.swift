import Foundation

public struct UserID: Hashable, Codable, Sendable {
    public let value: UUID

    public init(value: UUID = UUID()) {
        self.value = value
    }
}

public struct MealID: Hashable, Codable, Sendable {
    public let value: UUID

    public init(value: UUID = UUID()) {
        self.value = value
    }
}

public struct FoodID: Hashable, Codable, Sendable {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}
