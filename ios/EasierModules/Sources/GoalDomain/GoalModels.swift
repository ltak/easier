import Foundation

public struct GoalTarget: Codable, Equatable, Sendable {
    public let targetWeightKilograms: Double?
    public let targetBodyFatPercentage: Double?
    public let desiredWeeklyRate: Double?

    public init(
        targetWeightKilograms: Double?,
        targetBodyFatPercentage: Double?,
        desiredWeeklyRate: Double?
    ) {
        self.targetWeightKilograms = targetWeightKilograms
        self.targetBodyFatPercentage = targetBodyFatPercentage
        self.desiredWeeklyRate = desiredWeeklyRate
    }
}

public struct ProjectionScenario: Codable, Equatable, Sendable, Identifiable {
    public let id: UUID
    public let title: String
    public let expectedWeeks: Int
    public let summary: String

    public init(id: UUID = UUID(), title: String, expectedWeeks: Int, summary: String) {
        self.id = id
        self.title = title
        self.expectedWeeks = expectedWeeks
        self.summary = summary
    }
}
