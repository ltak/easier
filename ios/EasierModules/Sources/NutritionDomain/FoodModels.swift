import Foundation
import EasierDomain

public enum FoodSource: String, Codable, Sendable {
    case database
    case manual
    case aiEstimate
}

public enum ProcessingLevel: String, Codable, Sendable {
    case minimallyProcessed
    case processed
    case ultraProcessed
}

public struct MacroBreakdown: Codable, Equatable, Sendable {
    public let calories: Double
    public let proteinGrams: Double
    public let carbsGrams: Double
    public let fatGrams: Double
    public let fiberGrams: Double

    public init(
        calories: Double,
        proteinGrams: Double,
        carbsGrams: Double,
        fatGrams: Double,
        fiberGrams: Double
    ) {
        self.calories = calories
        self.proteinGrams = proteinGrams
        self.carbsGrams = carbsGrams
        self.fatGrams = fatGrams
        self.fiberGrams = fiberGrams
    }

    public static let zero = MacroBreakdown(
        calories: 0,
        proteinGrams: 0,
        carbsGrams: 0,
        fatGrams: 0,
        fiberGrams: 0
    )
}

public struct FoodItem: Identifiable, Codable, Equatable, Sendable {
    public let id: FoodID
    public let name: String
    public let per100Grams: MacroBreakdown
    public let processingLevel: ProcessingLevel

    public init(
        id: FoodID,
        name: String,
        per100Grams: MacroBreakdown,
        processingLevel: ProcessingLevel
    ) {
        self.id = id
        self.name = name
        self.per100Grams = per100Grams
        self.processingLevel = processingLevel
    }
}

public struct MealComponent: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let foodID: FoodID?
    public let name: String
    public let source: FoodSource
    public var grams: Double
    public let nutritionPer100Grams: MacroBreakdown
    public let processingLevel: ProcessingLevel

    public init(
        id: UUID = UUID(),
        foodID: FoodID?,
        name: String,
        source: FoodSource,
        grams: Double,
        nutritionPer100Grams: MacroBreakdown,
        processingLevel: ProcessingLevel
    ) {
        self.id = id
        self.foodID = foodID
        self.name = name
        self.source = source
        self.grams = grams
        self.nutritionPer100Grams = nutritionPer100Grams
        self.processingLevel = processingLevel
    }

    public var totals: MacroBreakdown {
        let multiplier = grams / 100
        return MacroBreakdown(
            calories: nutritionPer100Grams.calories * multiplier,
            proteinGrams: nutritionPer100Grams.proteinGrams * multiplier,
            carbsGrams: nutritionPer100Grams.carbsGrams * multiplier,
            fatGrams: nutritionPer100Grams.fatGrams * multiplier,
            fiberGrams: nutritionPer100Grams.fiberGrams * multiplier
        )
    }
}

public struct SatietyBreakdown: Codable, Equatable, Sendable {
    public let overallScore: Int
    public let proteinDensityScore: Int
    public let fiberScore: Int
    public let energyDensityScore: Int
    public let processedFoodPenalty: Int

    public init(
        overallScore: Int,
        proteinDensityScore: Int,
        fiberScore: Int,
        energyDensityScore: Int,
        processedFoodPenalty: Int
    ) {
        self.overallScore = overallScore
        self.proteinDensityScore = proteinDensityScore
        self.fiberScore = fiberScore
        self.energyDensityScore = energyDensityScore
        self.processedFoodPenalty = processedFoodPenalty
    }
}

public struct MealIssue: Codable, Equatable, Sendable, Identifiable {
    public let id: UUID
    public let title: String
    public let detail: String

    public init(id: UUID = UUID(), title: String, detail: String) {
        self.id = id
        self.title = title
        self.detail = detail
    }
}

public struct MealAdjustmentSuggestion: Codable, Equatable, Sendable, Identifiable {
    public let id: UUID
    public let title: String
    public let detail: String
    public let estimatedCalorieDelta: Double
    public let estimatedSatietyDelta: Int

    public init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        estimatedCalorieDelta: Double,
        estimatedSatietyDelta: Int
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.estimatedCalorieDelta = estimatedCalorieDelta
        self.estimatedSatietyDelta = estimatedSatietyDelta
    }
}

public struct MealAnalysis: Codable, Equatable, Sendable {
    public let mealID: MealID?
    public let mealName: String
    public let components: [MealComponent]
    public let totals: MacroBreakdown
    public let satiety: SatietyBreakdown
    public let issues: [MealIssue]
    public let suggestions: [MealAdjustmentSuggestion]

    public init(
        mealID: MealID?,
        mealName: String,
        components: [MealComponent],
        totals: MacroBreakdown,
        satiety: SatietyBreakdown,
        issues: [MealIssue],
        suggestions: [MealAdjustmentSuggestion]
    ) {
        self.mealID = mealID
        self.mealName = mealName
        self.components = components
        self.totals = totals
        self.satiety = satiety
        self.issues = issues
        self.suggestions = suggestions
    }
}
