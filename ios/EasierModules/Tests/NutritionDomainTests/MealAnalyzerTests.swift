import XCTest
@testable import NutritionDomain
import EasierDomain

final class MealAnalyzerTests: XCTestCase {
    func testHighProteinMealScoresBetterThanProcessedSnackMeal() {
        let analyzer = MealAnalyzer()

        let highProteinMeal = analyzer.analyze(
            mealName: "High Protein Bowl",
            components: [
                MealComponent(
                    foodID: FoodID("chicken"),
                    name: "Chicken Breast",
                    source: .database,
                    grams: 180,
                    nutritionPer100Grams: .init(calories: 165, proteinGrams: 31, carbsGrams: 0, fatGrams: 3.6, fiberGrams: 0),
                    processingLevel: .minimallyProcessed
                ),
                MealComponent(
                    foodID: FoodID("potato"),
                    name: "Boiled Potato",
                    source: .database,
                    grams: 250,
                    nutritionPer100Grams: .init(calories: 87, proteinGrams: 2, carbsGrams: 20, fatGrams: 0.1, fiberGrams: 1.8),
                    processingLevel: .minimallyProcessed
                )
            ]
        )

        let processedMeal = analyzer.analyze(
            mealName: "Snack Meal",
            components: [
                MealComponent(
                    foodID: FoodID("chips"),
                    name: "Chips",
                    source: .database,
                    grams: 120,
                    nutritionPer100Grams: .init(calories: 536, proteinGrams: 7, carbsGrams: 53, fatGrams: 35, fiberGrams: 4),
                    processingLevel: .ultraProcessed
                )
            ]
        )

        XCTAssertGreaterThan(highProteinMeal.satiety.overallScore, processedMeal.satiety.overallScore)
        XCTAssertFalse(highProteinMeal.issues.contains(where: { $0.title == "Low satiety for the calories" }))
    }
}
