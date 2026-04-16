import Foundation
import NutritionDomain

public protocol FoodLoggingAPI {
    func analyzeMeal(request: AnalyzeMealRequest) async throws -> MealAnalysis
    func saveMeal(request: SaveMealRequest) async throws -> MealAnalysis
}

public struct AnalyzeMealRequest: Codable, Sendable {
    public let mealName: String
    public let components: [MealComponent]

    public init(mealName: String, components: [MealComponent]) {
        self.mealName = mealName
        self.components = components
    }
}

public struct SaveMealRequest: Codable, Sendable {
    public let mealName: String
    public let loggedAt: Date
    public let components: [MealComponent]

    public init(mealName: String, loggedAt: Date, components: [MealComponent]) {
        self.mealName = mealName
        self.loggedAt = loggedAt
        self.components = components
    }
}

public final class StubFoodLoggingAPI: FoodLoggingAPI {
    private let analyzer = MealAnalyzer()

    public init() {}

    public func analyzeMeal(request: AnalyzeMealRequest) async throws -> MealAnalysis {
        analyzer.analyze(mealName: request.mealName, components: request.components)
    }

    public func saveMeal(request: SaveMealRequest) async throws -> MealAnalysis {
        analyzer.analyze(mealName: request.mealName, components: request.components)
    }
}
