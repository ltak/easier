import type { FoodSource, MacroBreakdown, ProcessingLevel } from "../shared/types.js";

export interface MealComponentInput {
  foodId: string | null;
  name: string;
  grams: number;
  source: FoodSource;
  nutritionPer100Grams: MacroBreakdown;
  processingLevel: ProcessingLevel;
}

export interface AnalyzeMealRequest {
  mealName: string;
  components: MealComponentInput[];
}

export interface MealIssue {
  title: string;
  detail: string;
}

export interface MealAdjustmentSuggestion {
  title: string;
  detail: string;
  estimatedCalorieDelta: number;
  estimatedSatietyDelta: number;
}

export interface SatietyBreakdown {
  overallScore: number;
  proteinDensityScore: number;
  fiberScore: number;
  energyDensityScore: number;
  processedFoodPenalty: number;
}

export interface AnalyzeMealResponse {
  mealName: string;
  components: Array<MealComponentInput & { totals: MacroBreakdown }>;
  totals: MacroBreakdown;
  satiety: SatietyBreakdown;
  issues: MealIssue[];
  suggestions: MealAdjustmentSuggestion[];
}
