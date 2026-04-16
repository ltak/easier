# Food Logging System

## Context

Food logging is the first critical loop in Easier because every downstream feature depends on structured intake data and user trust.

## Problem

Most nutrition apps either optimize for speed and lose accuracy, or optimize for precision and become tedious. Easier needs to capture precise intake while still helping users make lower-hunger choices in the moment.

## Solution

Design food logging as a structured editing workflow:

- start fast with search, recent items, or AI estimate
- convert everything into meal components
- let the user edit grams and items directly
- immediately show calories, macros, satiety, and leverage points

## Output

### Goals

- Make precise gram-based logging the default for engaged users.
- Support incomplete or partial logs without punishing the user.
- Turn every meal into structured data suitable for analysis and reuse.
- Help users reduce calories and hunger through better meal composition, not just restriction.

### Non-goals

- Fully automated calorie tracking without user review
- AI-generated diet plans as the source of truth
- Gamified streak pressure around perfect logging

### Primary user problems

- “I can log food, but I don’t know what to change.”
- “Healthy enough meals still leave me hungry.”
- “Estimating meals is messy and hard to edit.”
- “One bad day makes the whole system feel broken.”

### Core user flow

1. User taps `Log Meal`.
2. User adds foods by search, recent items, saved meal, or AI estimate.
3. Meal editor shows each component with grams, macros, and calorie contribution.
4. System calculates totals plus satiety score and flags low-satiety calorie sources.
5. User accepts or edits suggestions.
6. User saves the meal.
7. Day dashboard updates calories, macros, and satiety pattern.

### Key UX rules

- Logging anything is success.
- AI estimates must come back as editable components.
- The system always shows what matters most: calories, protein, hunger impact, and easiest improvement.
- Suggestions should feel like edits, not judgments.

### Edge cases

- Partial meal with one unknown component
- Restaurant meal with hidden oils or sauces
- User logs after the fact and only knows rough portions
- Meal exceeds calorie target but has strong satiety
- Meal fits calories but has weak satiety and low protein

### Phase recommendation

- Good: search, grams, saved meals, analyze-before-save, meal-level satiety
- Better: AI estimate into components, recent foods, daily satiety trends
- Best: barcode and photo assist, restaurant decomposition memory, personalized satiety tuning

### Acceptance criteria

- Users can create and edit a meal using structured components.
- Every component has grams and nutrition values, or is clearly marked as estimated.
- The system returns meal calories, macros, and satiety breakdown on each edit.
- The system highlights at least one actionable opportunity when satiety is weak.
- Users can save a meal as both a log entry and reusable template.
- Partial logging is allowed without blocking save.

### Open questions

- How aggressive should the processed-food penalty be in v1?
- Should saved meals store exact grams only, or allow portion variants?
- How much estimation uncertainty should be shown in the UI for AI-derived components?

### Decision risks

- Too much coaching in the editor could create friction.
- Too little structure in AI outputs would undermine the whole system.
- Real-time recalculation latency can hurt the feeling of control.

## Tradeoffs / Considerations

- Precise gram editing is more effort than quick-add logging, but it unlocks better coaching and better projections.
- Analyze-before-save adds an extra server step, but keeps the meal editor trustworthy and reusable.
