# Easier API Shape

## Context

The first slice needs stable request and response contracts so iOS and backend can evolve independently.

## Problem

If API payloads are vague early on, AI and UI pressure will turn meal data into blobs that are hard to analyze later.

## Solution

Use structured, component-based JSON contracts from day one.

## Code / Output

### Food search

`GET /v1/foods/search?q=greek+yogurt`

Returns food matches with canonical macros and serving hints.

### Meal analysis

`POST /v1/meals/analyze`

```json
{
  "mealName": "Lunch bowl",
  "components": [
    {
      "foodId": "food_chicken_breast",
      "name": "Chicken breast",
      "grams": 180,
      "source": "database"
    },
    {
      "foodId": "food_rice_cooked",
      "name": "Cooked rice",
      "grams": 220,
      "source": "database"
    },
    {
      "foodId": null,
      "name": "Chipotle mayo",
      "grams": 30,
      "source": "manual"
    }
  ]
}
```

Returns:

- meal totals
- component totals
- satiety breakdown
- issues
- deterministic adjustment suggestions

### Meal logging

`POST /v1/meals`

Persists the analyzed meal as a meal entry in the day log.

### AI meal estimation

`POST /v1/ai/meal-estimates`

Accepts text or image references and returns structured components only. The client must still route those components through `/v1/meals/analyze` before save.

### Daily dashboard

`GET /v1/days/{date}`

Returns meals, macro totals, satiety totals, workout summary, and top coaching signal.

## Tradeoffs / Considerations

- Separating estimation from analysis keeps AI out of the source-of-truth path.
- A dedicated analyze endpoint supports the meal editor without forcing immediate persistence.
