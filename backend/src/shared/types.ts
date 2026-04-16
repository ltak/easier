export type FoodSource = "database" | "manual" | "aiEstimate";
export type ProcessingLevel = "minimallyProcessed" | "processed" | "ultraProcessed";

export interface MacroBreakdown {
  calories: number;
  proteinGrams: number;
  carbsGrams: number;
  fatGrams: number;
  fiberGrams: number;
}

export const zeroMacros = (): MacroBreakdown => ({
  calories: 0,
  proteinGrams: 0,
  carbsGrams: 0,
  fatGrams: 0,
  fiberGrams: 0
});
