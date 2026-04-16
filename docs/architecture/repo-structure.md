# Easier Repo Structure

## Context

Easier needs to move quickly across product, iOS, and backend without letting UI concerns bleed into core health logic.

## Problem

A flat greenfield repo turns into accidental coupling fast, especially when AI, projections, nutrition, and workouts all touch the same user loop.

## Solution

Use a three-part repo split with docs as the first source of truth and feature slices that map back to the core product loop.

## Output

```text
Easier/
  AGENTS.md
  README.md
  docs/
    product/
      food-logging.md
      meal-editor.md
      goals-and-projections.md
      workout-system.md
      coaching-system.md
    architecture/
      repo-structure.md
      domain-model.md
      system-architecture.md
      api-shape.md
      subagent-workflows.md
  ios/
    README.md
    EasierApp/
      App/
      Features/
        FoodLogging/
        MealEditor/
    EasierModules/
      Package.swift
      Sources/
        EasierDomain/
        NutritionDomain/
        GoalDomain/
        TrainingDomain/
        CoachingDomain/
        APIClient/
        DesignSystem/
      Tests/
        NutritionDomainTests/
  backend/
    package.json
    tsconfig.json
    src/
      app/
      contracts/
      domains/
        nutrition/
        goals/
        training/
        coaching/
      shared/
    test/
```

## Tradeoffs / Considerations

- Good: separate product, app, and service concerns immediately.
- Better: domain modules make deterministic logic testable before UI polish.
- Best later: generate clients or schemas from a contract source once the API stabilizes. Doing that now would slow iteration.
