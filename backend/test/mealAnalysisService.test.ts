import test from "node:test";
import assert from "node:assert/strict";
import { MealAnalysisService } from "../src/domains/nutrition/mealAnalysisService.js";

test("meal analysis gives higher satiety to higher-protein, lower-energy-density meals", () => {
  const service = new MealAnalysisService();

  const highSatietyMeal = service.analyze({
    mealName: "Chicken and Potatoes",
    components: [
      {
        foodId: "food_chicken_breast",
        name: "Chicken Breast",
        grams: 180,
        source: "database",
        processingLevel: "minimallyProcessed",
        nutritionPer100Grams: { calories: 165, proteinGrams: 31, carbsGrams: 0, fatGrams: 3.6, fiberGrams: 0 }
      },
      {
        foodId: "food_potato",
        name: "Boiled Potato",
        grams: 250,
        source: "database",
        processingLevel: "minimallyProcessed",
        nutritionPer100Grams: { calories: 87, proteinGrams: 2, carbsGrams: 20, fatGrams: 0.1, fiberGrams: 1.8 }
      }
    ]
  });

  const lowSatietyMeal = service.analyze({
    mealName: "Chips",
    components: [
      {
        foodId: "food_chips",
        name: "Potato Chips",
        grams: 120,
        source: "database",
        processingLevel: "ultraProcessed",
        nutritionPer100Grams: { calories: 536, proteinGrams: 7, carbsGrams: 53, fatGrams: 35, fiberGrams: 4 }
      }
    ]
  });

  assert.ok(highSatietyMeal.satiety.overallScore > lowSatietyMeal.satiety.overallScore);
  assert.ok(lowSatietyMeal.issues.length > 0);
});
