import Foundation

public enum CoachTone: String, Codable, CaseIterable, Sendable {
    case supportive
    case balanced
    case direct
}

public struct DailyInsight: Codable, Equatable, Sendable, Identifiable {
    public let id: UUID
    public let title: String
    public let message: String
    public let tone: CoachTone

    public init(id: UUID = UUID(), title: String, message: String, tone: CoachTone) {
        self.id = id
        self.title = title
        self.message = message
        self.tone = tone
    }
}
