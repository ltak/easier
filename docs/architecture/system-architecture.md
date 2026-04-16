# Easier System Architecture

## Context

Easier is a hybrid system: deterministic health logic plus selective AI assistance.

## Problem

The product can lose trust quickly if AI owns core logic or if the app becomes the policy layer.

## Solution

Use a strict split:

- backend owns deterministic calculations and persisted state
- iOS owns feature presentation and local interaction state
- AI is a supporting layer for estimation and explanation

## Code / Output

### iOS modules

- `EasierDomain`: app-level shared types with no health policy
- `NutritionDomain`: meal models, satiety scoring client models, adjustment view state helpers
- `GoalDomain`: goal configuration and projection response models
- `TrainingDomain`: workout plans, performance logs, recovery signals
- `CoachingDomain`: daily and weekly coaching payload models
- `APIClient`: HTTP clients, request/response mapping, caching
- `DesignSystem`: colors, typography, charts, cards, status treatments
- `Features/*`: screen-specific view models and SwiftUI views

### Backend modules

- `domains/nutrition`: food search, meal logging, satiety analysis, meal suggestions
- `domains/goals`: target setup, trend processing, deterministic projections
- `domains/training`: plans, logs, progression rules
- `domains/coaching`: insight selection, tone rendering inputs, AI request orchestration
- `contracts`: request and response payloads
- `shared`: ids, dates, errors, auth context, base result helpers

### Request flow

1. User logs or edits a meal in iOS.
2. `APIClient` sends structured meal components to backend.
3. Nutrition service recalculates macros, calories, satiety, and deterministic suggestions.
4. Backend returns structured analysis payload.
5. iOS view models render totals, issues, and suggestions.
6. If the user asks for help estimating or explanation, AI consumes structured payloads and returns text only.

## Tradeoffs / Considerations

- Keeping deterministic scoring on the backend improves consistency across clients.
- Real-time meal editing can later move some mirrored heuristics client-side if latency becomes an issue.
- Starting with server-owned logic is slower for instant offline feedback, but safer for correctness.
