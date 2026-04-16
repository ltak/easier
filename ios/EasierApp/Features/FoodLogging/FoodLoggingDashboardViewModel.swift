import Foundation
import SwiftUI
import APIClient
import NutritionDomain

@MainActor
final class FoodLoggingDashboardViewModel: ObservableObject {
    @Published private(set) var currentAnalysis: MealAnalysis

    private let api: any FoodLoggingAPI

    init(api: any FoodLoggingAPI) {
        self.api = api
        self.currentAnalysis = MealAnalysis(
            mealID: nil,
            mealName: "Lunch Bowl",
            components: Self.sampleComponents,
            totals: .zero,
            satiety: .init(overallScore: 0, proteinDensityScore: 0, fiberScore: 0, energyDensityScore: 0, processedFoodPenalty: 0),
            issues: [],
            suggestions: []
        )

        Task { await refreshAnalysis() }
    }

    func refreshAnalysis() async {
        do {
            currentAnalysis = try await api.analyzeMeal(
                request: AnalyzeMealRequest(mealName: currentAnalysis.mealName, components: currentAnalysis.components)
            )
        } catch {
            // Leave the previous state in place until an error strategy exists.
        }
    }

    func update(components: [MealComponent]) {
        currentAnalysis = MealAnalysis(
            mealID: currentAnalysis.mealID,
            mealName: currentAnalysis.mealName,
            components: components,
            totals: currentAnalysis.totals,
            satiety: currentAnalysis.satiety,
            issues: currentAnalysis.issues,
            suggestions: currentAnalysis.suggestions
        )

        Task { await refreshAnalysis() }
    }

    static let sampleComponents: [MealComponent] = [
        MealComponent(
            foodID: .init("chicken_breast"),
            name: "Chicken Breast",
            source: .database,
            grams: 180,
            nutritionPer100Grams: .init(calories: 165, proteinGrams: 31, carbsGrams: 0, fatGrams: 3.6, fiberGrams: 0),
            processingLevel: .minimallyProcessed
        ),
        MealComponent(
            foodID: .init("rice"),
            name: "Cooked Rice",
            source: .database,
            grams: 220,
            nutritionPer100Grams: .init(calories: 130, proteinGrams: 2.7, carbsGrams: 28, fatGrams: 0.3, fiberGrams: 0.4),
            processingLevel: .processed
        ),
        MealComponent(
            foodID: nil,
            name: "Chipotle Mayo",
            source: .manual,
            grams: 30,
            nutritionPer100Grams: .init(calories: 680, proteinGrams: 1, carbsGrams: 6, fatGrams: 74, fiberGrams: 0),
            processingLevel: .ultraProcessed
        )
    ]
}
