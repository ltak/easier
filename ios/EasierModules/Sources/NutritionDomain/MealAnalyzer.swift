import Foundation

public struct MealAnalyzer {
    public init() {}

    public func analyze(mealName: String, components: [MealComponent]) -> MealAnalysis {
        let totals = components.reduce(into: MacroBreakdown.zero) { partial, component in
            let componentTotals = component.totals
            partial = MacroBreakdown(
                calories: partial.calories + componentTotals.calories,
                proteinGrams: partial.proteinGrams + componentTotals.proteinGrams,
                carbsGrams: partial.carbsGrams + componentTotals.carbsGrams,
                fatGrams: partial.fatGrams + componentTotals.fatGrams,
                fiberGrams: partial.fiberGrams + componentTotals.fiberGrams
            )
        }

        let satiety = satietyBreakdown(for: totals, components: components)
        let issues = mealIssues(for: totals, satiety: satiety, components: components)
        let suggestions = mealSuggestions(for: totals, satiety: satiety, components: components)

        return MealAnalysis(
            mealID: nil,
            mealName: mealName,
            components: components,
            totals: totals,
            satiety: satiety,
            issues: issues,
            suggestions: suggestions
        )
    }

    private func satietyBreakdown(for totals: MacroBreakdown, components: [MealComponent]) -> SatietyBreakdown {
        let calories = max(totals.calories, 1)
        let totalWeight = max(components.reduce(0) { $0 + $1.grams }, 1)

        let proteinDensity = totals.proteinGrams / (calories / 100)
        let fiberDensity = totals.fiberGrams / (calories / 100)
        let energyDensity = calories / totalWeight
        let processedRatio = Double(components.filter { $0.processingLevel == .ultraProcessed }.count) / Double(max(components.count, 1))

        let proteinScore = boundedScore(proteinDensity * 8, upperBound: 35)
        let fiberScore = boundedScore(fiberDensity * 15, upperBound: 25)
        let energyDensityScore = boundedScore((4 - energyDensity) * 10, upperBound: 30)
        let processedPenalty = boundedScore(processedRatio * 25, upperBound: 20)
        let overall = max(0, min(100, proteinScore + fiberScore + energyDensityScore - processedPenalty))

        return SatietyBreakdown(
            overallScore: overall,
            proteinDensityScore: proteinScore,
            fiberScore: fiberScore,
            energyDensityScore: energyDensityScore,
            processedFoodPenalty: processedPenalty
        )
    }

    private func mealIssues(
        for totals: MacroBreakdown,
        satiety: SatietyBreakdown,
        components: [MealComponent]
    ) -> [MealIssue] {
        var issues: [MealIssue] = []

        if satiety.overallScore < 45 {
            issues.append(
                MealIssue(
                    title: "Low satiety for the calories",
                    detail: "This meal is likely to leave you hungry relative to its calorie load."
                )
            )
        }

        if totals.proteinGrams < 25 {
            issues.append(
                MealIssue(
                    title: "Protein is light",
                    detail: "Adding protein would improve fullness and recovery support."
                )
            )
        }

        if components.contains(where: { $0.totals.calories > 150 && $0.processingLevel == .ultraProcessed }) {
            issues.append(
                MealIssue(
                    title: "Easy calories hiding in processed items",
                    detail: "One or more processed components are adding calories without much fullness."
                )
            )
        }

        return issues
    }

    private func mealSuggestions(
        for totals: MacroBreakdown,
        satiety: SatietyBreakdown,
        components: [MealComponent]
    ) -> [MealAdjustmentSuggestion] {
        var suggestions: [MealAdjustmentSuggestion] = []

        if let highestCalorie = components.max(by: { $0.totals.calories < $1.totals.calories }),
           highestCalorie.processingLevel != .minimallyProcessed,
           highestCalorie.totals.calories > 100 {
            suggestions.append(
                MealAdjustmentSuggestion(
                    title: "Reduce \(highestCalorie.name)",
                    detail: "Cutting a modest portion here is the fastest calorie save.",
                    estimatedCalorieDelta: -highestCalorie.totals.calories * 0.25,
                    estimatedSatietyDelta: 2
                )
            )
        }

        if totals.proteinGrams < 30 {
            suggestions.append(
                MealAdjustmentSuggestion(
                    title: "Add a lean protein",
                    detail: "Push this meal closer to 30g+ protein to improve fullness.",
                    estimatedCalorieDelta: 120,
                    estimatedSatietyDelta: 12
                )
            )
        }

        if satiety.overallScore < 60 {
            suggestions.append(
                MealAdjustmentSuggestion(
                    title: "Add volume food",
                    detail: "Vegetables, fruit, or potatoes can improve fullness without a big calorie jump.",
                    estimatedCalorieDelta: 80,
                    estimatedSatietyDelta: 10
                )
            )
        }

        return Array(suggestions.prefix(3))
    }

    private func boundedScore(_ rawValue: Double, upperBound: Int) -> Int {
        Int(Swift.max(0, Swift.min(Double(upperBound), rawValue.rounded())))
    }
}
