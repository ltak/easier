import type {
  AnalyzeMealRequest,
  AnalyzeMealResponse,
  MealAdjustmentSuggestion,
  MealIssue,
  SatietyBreakdown
} from "../../contracts/mealContracts.js";
import { zeroMacros } from "../../shared/types.js";

export class MealAnalysisService {
  analyze(request: AnalyzeMealRequest): AnalyzeMealResponse {
    const components = request.components.map((component) => {
      const multiplier = component.grams / 100;

      return {
        ...component,
        totals: {
          calories: component.nutritionPer100Grams.calories * multiplier,
          proteinGrams: component.nutritionPer100Grams.proteinGrams * multiplier,
          carbsGrams: component.nutritionPer100Grams.carbsGrams * multiplier,
          fatGrams: component.nutritionPer100Grams.fatGrams * multiplier,
          fiberGrams: component.nutritionPer100Grams.fiberGrams * multiplier
        }
      };
    });

    const totals = components.reduce((result, component) => {
      result.calories += component.totals.calories;
      result.proteinGrams += component.totals.proteinGrams;
      result.carbsGrams += component.totals.carbsGrams;
      result.fatGrams += component.totals.fatGrams;
      result.fiberGrams += component.totals.fiberGrams;
      return result;
    }, zeroMacros());

    const satiety = this.calculateSatiety(totals, request.components);
    const issues = this.collectIssues(totals, satiety, components);
    const suggestions = this.collectSuggestions(totals, satiety, components);

    return {
      mealName: request.mealName,
      components,
      totals,
      satiety,
      issues,
      suggestions
    };
  }

  private calculateSatiety(
    totals: AnalyzeMealResponse["totals"],
    components: AnalyzeMealRequest["components"]
  ): SatietyBreakdown {
    const calories = Math.max(totals.calories, 1);
    const totalWeight = Math.max(components.reduce((sum, item) => sum + item.grams, 0), 1);
    const processedRatio =
      components.filter((component) => component.processingLevel === "ultraProcessed").length /
      Math.max(components.length, 1);

    const proteinScore = this.boundScore((totals.proteinGrams / (calories / 100)) * 8, 35);
    const fiberScore = this.boundScore((totals.fiberGrams / (calories / 100)) * 15, 25);
    const energyDensityScore = this.boundScore((4 - totals.calories / totalWeight) * 10, 30);
    const processedFoodPenalty = this.boundScore(processedRatio * 25, 20);
    const overallScore = Math.max(0, Math.min(100, proteinScore + fiberScore + energyDensityScore - processedFoodPenalty));

    return {
      overallScore,
      proteinDensityScore: proteinScore,
      fiberScore,
      energyDensityScore,
      processedFoodPenalty
    };
  }

  private collectIssues(
    totals: AnalyzeMealResponse["totals"],
    satiety: SatietyBreakdown,
    components: AnalyzeMealResponse["components"]
  ): MealIssue[] {
    const issues: MealIssue[] = [];

    if (satiety.overallScore < 45) {
      issues.push({
        title: "Low satiety for the calories",
        detail: "This meal is likely to leave the user hungry relative to its calorie load."
      });
    }

    if (totals.proteinGrams < 25) {
      issues.push({
        title: "Protein is light",
        detail: "Adding protein is the clearest way to improve fullness and recovery support."
      });
    }

    if (components.some((component) => component.processingLevel === "ultraProcessed" && component.totals.calories > 150)) {
      issues.push({
        title: "Processed calories are doing a lot of work",
        detail: "One or more components are adding easy calories without much fullness."
      });
    }

    return issues;
  }

  private collectSuggestions(
    totals: AnalyzeMealResponse["totals"],
    satiety: SatietyBreakdown,
    components: AnalyzeMealResponse["components"]
  ): MealAdjustmentSuggestion[] {
    const suggestions: MealAdjustmentSuggestion[] = [];
    const highestCalorieComponent = [...components].sort((left, right) => right.totals.calories - left.totals.calories)[0];

    if (
      highestCalorieComponent &&
      highestCalorieComponent.processingLevel !== "minimallyProcessed" &&
      highestCalorieComponent.totals.calories > 100
    ) {
      suggestions.push({
        title: `Reduce ${highestCalorieComponent.name}`,
        detail: "A modest portion cut here is the fastest calorie save.",
        estimatedCalorieDelta: -Math.round(highestCalorieComponent.totals.calories * 0.25),
        estimatedSatietyDelta: 2
      });
    }

    if (totals.proteinGrams < 30) {
      suggestions.push({
        title: "Add a lean protein",
        detail: "Pushing the meal over 30g protein should improve fullness noticeably.",
        estimatedCalorieDelta: 120,
        estimatedSatietyDelta: 12
      });
    }

    if (satiety.overallScore < 60) {
      suggestions.push({
        title: "Add volume food",
        detail: "Vegetables, fruit, or potatoes can improve fullness without a big calorie jump.",
        estimatedCalorieDelta: 80,
        estimatedSatietyDelta: 10
      });
    }

    return suggestions.slice(0, 3);
  }

  private boundScore(value: number, max: number): number {
    return Math.max(0, Math.min(max, Math.round(value)));
  }
}
