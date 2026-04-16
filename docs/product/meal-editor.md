# Meal Editor

## Context

The meal editor is where Easier turns logging into decision support.

## Problem

If the editor only behaves like a spreadsheet, users still have to figure out hunger and calorie tradeoffs alone.

## Solution

Make the editor an interactive meal workbench that answers:

- what is driving calories
- how filling is this meal
- what should I change first

## Output

### Core sections

- Header: meal name, meal time, save state
- Components list: editable grams, calories, macros
- Totals card: calories, protein, carbs, fat, fiber
- Satiety card: overall score plus breakdown drivers
- Suggestions card: top 1 to 3 deterministic edits

### Interaction rules

- Editing grams recalculates the meal immediately.
- Suggestions update after each edit.
- Users can remove or ignore suggestions with no penalty.
- Unknown foods stay editable and clearly labeled.

### Acceptance criteria

- Users can add, delete, and reorder meal components.
- Users see meal totals and satiety feedback after each change.
- At least one suggestion can be applied as a quick action.
- The editor never hides the structured component list behind AI text.
