# Easier

Easier helps people reach fat loss, muscle gain, or maintenance goals with less hunger, less friction, and better decisions.

## Product loop

`Plan -> Track -> Analyze -> Adjust -> Predict`

## Repo structure

- `docs/product`: feature specs and flows
- `docs/architecture`: modules, domain model, API shape, and system decisions
- `ios`: SwiftUI app structure plus modular Swift packages
- `backend`: deterministic services for logging, goals, workouts, projections, and coaching

## Current focus

The first implemented slice is `Food Logging + Meal Editor`, because it unlocks:

- precise intake data
- satiety coaching
- reusable meals
- deterministic projections downstream

## Architecture direction

- SwiftUI app with modular feature and domain packages
- TypeScript backend with deterministic domain services
- AI limited to estimation, explanation, summaries, and tone adaptation
- Deterministic systems own nutrition scoring, projections, and training rules
