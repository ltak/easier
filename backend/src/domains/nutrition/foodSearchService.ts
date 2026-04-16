import type { MacroBreakdown, ProcessingLevel } from "../../shared/types.js";

export interface FoodSearchResult {
  id: string;
  name: string;
  processingLevel: ProcessingLevel;
  per100Grams: MacroBreakdown;
}

const seedFoods: FoodSearchResult[] = [
  {
    id: "food_chicken_breast",
    name: "Chicken Breast",
    processingLevel: "minimallyProcessed",
    per100Grams: { calories: 165, proteinGrams: 31, carbsGrams: 0, fatGrams: 3.6, fiberGrams: 0 }
  },
  {
    id: "food_greek_yogurt",
    name: "Greek Yogurt",
    processingLevel: "processed",
    per100Grams: { calories: 59, proteinGrams: 10, carbsGrams: 3.6, fatGrams: 0.4, fiberGrams: 0 }
  },
  {
    id: "food_potato",
    name: "Potato",
    processingLevel: "minimallyProcessed",
    per100Grams: { calories: 87, proteinGrams: 2, carbsGrams: 20, fatGrams: 0.1, fiberGrams: 1.8 }
  }
];

export class FoodSearchService {
  search(query: string): FoodSearchResult[] {
    const normalizedQuery = query.trim().toLowerCase();

    if (!normalizedQuery) {
      return [];
    }

    return seedFoods.filter((food) => food.name.toLowerCase().includes(normalizedQuery));
  }
}
