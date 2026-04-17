# Easier App Flow And Mocked Services

## Context

Easier should feel like a real product before the backend is fully built. The app needs to prove the core loop and the decision quality of each tab before we harden server behavior.

For now, the app should be organized around three top-level tabs:

1. Nutrition
2. Fitness
3. Wearables / Health

The backend should be mocked behind realistic service contracts so we can shape the product without locking in the wrong implementation too early.

## Problem

If we build the backend first, we risk hardening the wrong contracts before the app experience is pressure-tested. If we build the app with loose fake data and no service structure, we risk designing screens that cannot later connect cleanly to real deterministic systems.

We need a middle path:

- app-first for flow, priorities, and trust
- realistic mocked services for contracts and state
- deterministic backend built later behind the same seams

## Solution

Use a tabbed SwiftUI app with mocked service protocols for each domain. Each tab should feel real, but every screen should be powered by stubbed domain responses that match the backend we expect to build later.

## Output

### Product loop mapping

The app should express the Easier loop like this:

- `Plan`: goals, plan setup, weekly structure
- `Track`: meals, workouts, wearable data, body signals
- `Analyze`: satiety, progress, recovery, trend interpretation
- `Adjust`: next best meal edit, next workout action, recovery guidance
- `Predict`: goal timeline, likely path, effect of small changes

That loop should be visible across tabs, not hidden inside one dashboard.

### Tab strategy

#### Tab 1: Nutrition

This is the first and strongest tab. It should prove the highest-value loop first.

Primary jobs:

- log meals
- edit structured components
- add foods from a backlog catalog or quick search
- estimate a dish from photo or free-form dish description when no exact item exists
- let the user correct the estimate with grams, ounces, calories, or ingredient edits
- see calories, macros, satiety, and leverage points
- review today’s nutrition state
- understand what to change next

Recommended v1 screens:

- Nutrition Home
- Meal Editor
- Food Search / Add Food
- Photo / AI Estimate Review
- Saved Meals / Recent Foods
- Daily Nutrition Summary

Nutrition Home should answer:

- how am I doing today
- what target calories and macros am I trying to hit
- where am I currently against those targets
- what meal or pattern matters most
- what is the next best nutrition change

Meal Editor should remain the most detailed workflow in the app.
It should support both exact food selection and AI-assisted estimation, but every estimate should end as editable structured inputs before save.

#### Tab 2: Fitness

This tab should stay simpler than nutrition in v1. It exists to connect training behavior to body recomposition, not to become a giant workout app.

Primary jobs:

- build and adjust a weekly training regimen
- view current plan
- choose or generate schedule templates such as push/pull/legs, full body, or heavy/light/medium
- log workout sessions
- see progression decisions
- compare what is working versus what is not over time
- use chat to help shape and revise the plan
- connect recovery and nutrition signals to training

Recommended v1 screens:

- Fitness Home
- Current Plan
- Weekly Training Plan Builder
- Plan Template Picker
- Workout Session Logger
- Exercise History
- Recovery Signals

Fitness Home should answer:

- what workout is next
- what regimen I am currently following this week
- whether recovery looks supported or compromised
- what progression decision is likely next

#### Tab 3: Wearables / Health

This tab should be the passive-input and trend tab. It should organize body signals without feeling like a raw data dump.

Primary jobs:

- show wearable and health inputs
- display weight and body trends
- show readiness or recovery context
- support projections and coaching inputs

Recommended v1 screens:

- Health Home
- Weight Check-In
- Weight Trend
- Recovery / Readiness
- Sleep and Activity Summary
- Connected Sources / Permissions

Health Home should answer:

- where body weight and mood are trending
- what signals are moving
- whether recovery or behavior is helping or hurting progress
- when the current pace likely hits the goal weight
- what changes those signals imply for nutrition or training

The better default is to keep weight logging and mood in the Health tab instead of creating a separate weight-only tab. Those signals are most useful when they sit next to wearables, recovery, and trend context rather than becoming their own isolated destination too early.

### App shell recommendation

Use a root `TabView` with one navigation stack per tab.

Recommended shell:

```text
TabView
  NutritionTab
    NavigationStack
  FitnessTab
    NavigationStack
  HealthTab
    NavigationStack
```

Why:

- each tab needs independent drill-in flows
- users should be able to bounce between tabs without losing local context
- this will scale better once each tab has multiple screens and sheets

### Mocked service layer

The mocked service layer should feel like the future backend, not like random local fake data.

Use separate service protocols by domain:

```text
ios/EasierModules/Sources/APIClient/
  NutritionAPI.swift
  FitnessAPI.swift
  HealthAPI.swift
  GoalAPI.swift
  CoachingAPI.swift
```

For now, each should have a stub implementation:

```text
StubNutritionAPI
StubFitnessAPI
StubHealthAPI
StubGoalAPI
StubCoachingAPI
```

### Mocking rules

- Stub responses should match realistic backend payload shapes.
- Mock data should have enough variation to expose good and bad states.
- The UI should never depend on “magic local state” that cannot later come from an API.
- Mocks should support loading, empty, healthy, weak, and edge-case states.

Avoid:

- one perfect happy-path model everywhere
- screens that construct business logic in the view layer
- local fake state that bypasses the service seam

### Recommended service responsibilities

#### NutritionAPI

- analyze meal
- save meal
- fetch nutrition day summary
- fetch recent foods
- fetch saved meals
- search foods

#### FitnessAPI

- fetch current plan
- fetch upcoming workout
- save workout session
- fetch exercise history
- fetch recovery signals

#### HealthAPI

- fetch daily health summary
- fetch weight trend
- fetch sleep and activity summary
- fetch wearable connection state

#### GoalAPI

- fetch current goal target
- fetch projection scenarios
- fetch projected time to goal based on current trend and intake assumptions

#### CoachingAPI

- fetch daily insight
- fetch weekly summary
- fetch structured nudges and gain-oriented suggestions grounded in deterministic signals

Goal and coaching may not need their own tab yet, but they should still have explicit service seams because their data will appear inside the three-tab experience.
The coaching layer should be able to turn domain signals into timely nudges about better meal choices, recovery support, and other high-leverage gains without becoming the owner of the underlying rules.

### Screen-level flow

#### Nutrition tab flow

1. User lands on Nutrition Home.
2. App shows today summary, target calories/macros, current progress against target, strongest issue, and best next change.
3. User taps `Log Meal`, searches the backlog catalog, or starts an AI estimate from text or photo.
4. Meal Editor updates from mocked analysis responses on edit and always lets the user correct the estimate before save.
5. Save routes through mocked save call.
6. Nutrition Home refreshes from mocked day summary.

#### Fitness tab flow

1. User lands on Fitness Home.
2. App shows the current regimen, next workout, recent completion, and recovery context.
3. User builds or adjusts the weekly plan from templates or chat guidance.
4. User opens a workout session.
5. User logs sets and completes the session.
6. Stub service returns progression decision and updated summary state.

#### Health tab flow

1. User lands on Health Home.
2. App shows weight trend, projected time to goal, sleep/activity summary, readiness context, and a lightweight mood/body check-in.
3. User drills into trends, check-ins, or connected sources.
4. Stub service returns realistic time-series and permission states.

### Suggested app-first build order

Build in this order:

1. App shell and tab structure
2. Nutrition Home + existing Meal Editor flow
3. Shared mocked service container
4. Fitness Home + workout logging slice
5. Fitness plan builder + template slice
6. Health Home + trend slice
7. Goal/projection cards embedded into Health or Nutrition
8. Coaching cards embedded across tabs

This keeps the strongest loop first while still shaping the full product.

### Current code implication

The current app already has a useful seam:

- [`ios/EasierModules/Sources/APIClient/FoodLoggingAPI.swift`](/Users/lucas/Documents/Easier/ios/EasierModules/Sources/APIClient/FoodLoggingAPI.swift)

That should evolve into domain-specific APIs rather than one growing food-only stub.

Recommended near-term change:

- rename or expand `FoodLoggingAPI` into `NutritionAPI`
- add sibling APIs for `Fitness` and `Health`
- inject all stub services from the app root

### Good vs Better vs Best

#### Good

Build the three-tab shell and keep most data stubbed inside view models.

Why it helps:

- fast to prototype

Why it is weak:

- too easy to blur UI and service responsibilities

#### Better

Build the three-tab shell with domain service protocols and stub implementations in `APIClient`.

Why it helps:

- keeps contracts realistic
- easier backend swap later
- better state modeling

#### Best

Add domain-specific APIs, shared app container wiring, state fixtures for multiple scenarios, and preview/test support built on the same stubs.

Why it helps:

- strongest product iteration loop
- easiest migration path to real backend
- best support for loading, empty, edge, and failure states

### Recommendation

Use the `better` path now.

That means:

- build the three-tab shell
- keep mocked domain service protocols
- make Nutrition the deepest slice first
- keep Fitness and Health intentionally lighter, but real enough to shape priorities

## Tradeoffs / Considerations

- App-first with mocked services is the right product move here, but only if the service seams stay disciplined.
- Nutrition should be the most complete tab first because it drives the strongest trust loop.
- Fitness and Health should not try to “catch up” in feature depth immediately; they should prove role clarity first.
- Goal projections and coaching can be embedded before they deserve dedicated navigation.
- The backend should follow the app once the contracts and decisions feel stable, not before.
