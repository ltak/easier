# Easier Domain Model

## Context

The product promise depends on turning messy inputs into structured decisions.

## Problem

If nutrition, workouts, projections, and coaching do not have explicit ownership, the app will drift into mixed logic, duplicated calculations, and fragile AI behavior.

## Solution

Model the system around four deterministic domains and one thin cross-cutting app layer.

## Output

### Shared concepts

- `UserProfile`: body data, preferences, coaching tone, dietary constraints
- `DailyLog`: normalized record of meals, workouts, body metrics, and adherence signals
- `CoachTone`: `supportive`, `balanced`, `direct`
- `AdjustmentOption`: deterministic change with expected impact and optional AI explanation

### Nutrition domain

- `FoodItem`: canonical food entity with macros, fiber, serving metadata, and processing level
- `FoodEntry`: food + grams + source of truth
- `MealComponent`: editable line item in a meal
- `LoggedMeal`: meal aggregate with totals, satiety score, and flags
- `MealTemplate`: reusable saved meal
- `SatietyScore`: protein density, fiber density, energy density, processed penalty, final score
- `MealIssue`: high-calorie low-satiety signal
- `MealAdjustmentSuggestion`: deterministic swap or edit suggestion

### Goal and projection domain

- `GoalTarget`: target weight or body-fat target with target pace bounds
- `WeightTrendPoint`: smoothed bodyweight trend point
- `ProjectionScenario`: baseline or adjusted scenario with expected timeline
- `ProjectionInputs`: trend, intake adherence, activity assumptions

### Training domain

- `WorkoutPlan`: plan template and schedule
- `WorkoutSession`: performed workout with exercises, sets, reps, load, RPE
- `ProgressionDecision`: deterministic next-step change for exercise prescription
- `RecoveryImpact`: nutrition-to-training signal such as low-calorie or high-protein support

### Coaching domain

- `DailyInsight`: one strongest suggestion for today
- `WeeklySummary`: wins, constraints, leverage points, and next action
- `BehaviorSignal`: logging consistency, recovery after misses, hunger hotspots
- `CoachingMessage`: rendered message in selected tone from deterministic insight payload

## Tradeoffs / Considerations

- Deterministic domains increase trust for health-related decisions.
- AI stays useful without becoming the source of truth.
- Shared concepts are intentionally small to avoid a giant “core” module too early.
