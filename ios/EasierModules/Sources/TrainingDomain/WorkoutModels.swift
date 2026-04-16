import Foundation

public struct WorkoutPlan: Codable, Equatable, Sendable, Identifiable {
    public let id: UUID
    public let name: String
    public let split: String

    public init(id: UUID = UUID(), name: String, split: String) {
        self.id = id
        self.name = name
        self.split = split
    }
}
