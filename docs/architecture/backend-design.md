# Easier Backend Design

## Context

Easier is a goal-driven recomposition system. The backend should be the trusted owner of deterministic health logic so iOS can stay focused on presentation and AI can stay limited to estimation and explanation.

The product loop is:

`Plan -> Track -> Analyze -> Adjust -> Predict`

The backend design should map directly to that loop.

## Problem

The current backend is a good spike, but it is still shaped like a single Fastify entrypoint that instantiates domain services directly. That is enough to prove the first slice, but not enough to scale cleanly once we add persistence, auth, versioned policies, and richer cross-domain decisions.

If we do not make backend ownership explicit now, we will drift into:

- route handlers that contain business logic
- duplicated calculations across iOS and backend
- AI payloads becoming source-of-truth data
- domain rules coupled to transport or storage details
- hard-to-review changes when projections, logging, and coaching start interacting

## Solution

Design the backend around deterministic domain services, thin HTTP routes, and explicit repository boundaries.

### Core principles

- Backend owns calculations, scoring, projections, and policy rules.
- iOS owns rendering, local interaction state, and optimistic UX only.
- AI can suggest or explain, but never becomes the source of truth for nutrition, projections, or coaching decisions.
- Contracts stay structured and versionable.
- Cross-domain orchestration should be explicit and rare.
- Storage and external APIs should sit behind repositories or gateways, not inside rules code.

## Current state

Today the backend already has the right high-level split:

- `app/server.ts` exposes HTTP endpoints
- `domains/nutrition` contains food search and meal analysis logic
- `domains/goals` contains projection scaffolding
- `domains/training` contains workout plan scaffolding
- `domains/coaching` contains daily coaching scaffolding
- `contracts` defines request and response payloads
- `shared` contains shared types and helpers

That is a strong starting point because the first real deterministic rule already lives in the right place:

- [`backend/src/domains/nutrition/mealAnalysisService.ts`](/Users/lucas/Documents/Easier/backend/src/domains/nutrition/mealAnalysisService.ts)

The main design gap is not domain direction. It is runtime structure and future ownership:

- services are manually instantiated in [`backend/src/app/server.ts`](/Users/lucas/Documents/Easier/backend/src/app/server.ts)
- routes and application wiring live in one file
- persistence boundaries do not exist yet
- request validation and auth context are not modeled yet
- coaching and projections are still static placeholders

## Recommended backend shape

### Layering

Use four backend layers:

1. Transport
2. Application
3. Domain
4. Infrastructure

### 1. Transport layer

Owns HTTP concerns only.

Responsibilities:

- Fastify app setup
- route registration
- request parsing and validation
- auth/session extraction
- mapping domain/application errors into HTTP responses
- response serialization

Should not own:

- satiety rules
- projection math
- coaching selection logic
- persistence details

Suggested shape:

```text
backend/src/app/
  server.ts
  plugins/
    auth.ts
    errors.ts
    validation.ts
  routes/
    healthRoutes.ts
    nutritionRoutes.ts
    goalRoutes.ts
    trainingRoutes.ts
    coachingRoutes.ts
```

### 2. Application layer

Owns orchestration across domains and repositories when a use case is bigger than a single domain method.

Use this layer only when it improves clarity. Do not add it for simple pass-through calls.

Good candidates:

- analyze meal then save meal log
- build daily dashboard from meals, workouts, and top coaching signal
- compute projection inputs from logs plus current goal target
- generate coaching payload from deterministic signals plus optional AI rendering request

Suggested shape:

```text
backend/src/application/
  nutrition/
    analyzeMeal.ts
    logMeal.ts
  dashboard/
    getDailyDashboard.ts
  goals/
    getProjectionScenarios.ts
  coaching/
    getDailyCoaching.ts
```

Rule of thumb:

- If one route calls one domain service method, skip the application layer.
- If one route coordinates multiple repositories/services or starts owning flow logic, add an application use case.

### 3. Domain layer

Owns deterministic product logic. This is the most important layer.

Each domain should contain:

- entities/value objects when helpful
- rule/policy services
- mappers from raw persisted data into domain inputs if needed
- repository interfaces only when persistence is required

Suggested shape:

```text
backend/src/domains/
  nutrition/
    models/
    services/
    policies/
    repositories/
  goals/
    models/
    services/
    policies/
    repositories/
  training/
    models/
    services/
    policies/
    repositories/
  coaching/
    models/
    services/
    policies/
    repositories/
```

Domain ownership should be:

- `nutrition`: food lookup, meal analysis, satiety scoring, meal issues, adjustment suggestions
- `goals`: target policies, trend processing, projection scenarios, pace guardrails
- `training`: plan templates, workout logging rules, progression decisions, recovery-related deterministic signals
- `coaching`: signal prioritization, message input payloads, explanation/rendering requests

### 4. Infrastructure layer

Owns persistence and external integrations.

Responsibilities:

- database implementations
- external nutrition data providers
- AI provider clients
- analytics/event publishing
- caching

Suggested shape:

```text
backend/src/infrastructure/
  persistence/
    inMemory/
    postgres/
  nutrition/
    foodDatabaseClient.ts
  ai/
    coachingRenderer.ts
    mealEstimator.ts
```

The infrastructure layer may change often. Domain rules should not.

## Domain-by-domain design

### Nutrition

This is the most mature backend slice and should remain the model for the rest of the system.

#### Inputs

- structured meal components
- canonical nutrition per 100g
- processing level
- source type: `database`, `manual`, `aiEstimate`

#### Responsibilities

- calculate component and meal totals
- calculate satiety subscores and final score
- detect meal issues
- generate deterministic adjustment suggestions
- later: persist logged meals and meal templates

#### Non-responsibilities

- free-form AI advice generation
- UI-friendly formatting decisions
- image understanding

#### Important rule

Any AI-estimated meal must still be converted into structured components and routed through the same deterministic analysis path before save.

That keeps:

- satiety consistent
- suggestions comparable
- downstream dashboard/projection inputs trustworthy

### Goals and projections

This domain should own prediction logic, not the client and not AI.

Responsibilities:

- goal target definition
- safe pace policies
- smoothed trend inputs
- baseline and adjusted scenarios
- deterministic explanations of why scenarios differ

Projection outputs should be based on stable domain inputs, for example:

- current weight trend
- adherence consistency
- logged intake patterns
- activity assumptions

AI can explain a projection. It should not calculate one.

### Training

Training should stay deterministic and relatively narrow early on.

Responsibilities:

- plan templates
- workout session logging
- progression decisions
- recovery-impact signals shared with coaching

Do not overload training with generic “program intelligence” too early. Start with explicit rules that are easy to test and explain.

### Coaching

Coaching is where deterministic logic and AI touch, so the boundary must stay very clear.

Split coaching into two stages:

1. Signal selection
2. Message rendering

Signal selection should be deterministic.

Examples:

- biggest calorie leak today
- missed protein target three days in a row
- weight trend on track but adherence weakening
- recovery risk after low-calorie intake and hard session

Message rendering can be:

- deterministic template-based copy first
- optional AI rewrite second, constrained by structured inputs and tone

That keeps coaching useful without making it unreviewable.

## Data flow

### Meal analysis flow

```text
iOS Meal Editor
  -> POST /v1/meals/analyze
  -> nutrition application/domain service
  -> deterministic totals + satiety + issues + suggestions
  -> structured response
  -> iOS renders editor state
```

### Meal logging flow

```text
iOS Meal Editor
  -> POST /v1/meals
  -> validate request
  -> analyze meal through same deterministic path
  -> persist logged meal
  -> publish updated day summary inputs
  -> return saved meal + analysis
```

### Daily dashboard flow

```text
iOS Dashboard
  -> GET /v1/days/{date}
  -> load daily meals, workouts, body data
  -> build deterministic aggregates
  -> ask coaching domain for top signal
  -> optionally render coaching copy
  -> return one structured day payload
```

## API design guidance

Keep contracts structured and explicit.

Good:

- numeric macro fields
- processing level enum
- source enum
- separate deterministic response sections for totals, issues, suggestions

Avoid:

- raw AI blobs in saved records
- mixed request shapes where some clients send structured inputs and others send text
- endpoint behavior that changes based on hidden flags

Recommended API stance:

- `POST /v1/meals/analyze`: deterministic, non-persistent
- `POST /v1/meals`: persistent, but still routes through deterministic analysis first
- `GET /v1/days/{date}`: aggregated read model for the dashboard
- AI estimation endpoints return structured candidates only, never final saved analysis

## State and storage ownership

The backend should become the source of truth for:

- logged meals
- day summaries
- goal targets
- weight trend inputs
- workout logs
- deterministic coaching signals

The client can keep:

- transient editor state
- local draft inputs
- view presentation state
- short-lived caching for responsiveness

## Error and validation design

Add explicit request validation before the backend grows.

Validate:

- grams are positive and realistic
- macro fields are non-negative
- required identifiers are present when `source = database`
- enums are recognized
- user-authenticated writes are scoped to the correct user

Use domain-friendly error categories:

- `validation_error`
- `not_found`
- `conflict`
- `policy_blocked`
- `unexpected_error`

This will matter once iOS needs stable failure handling.

## Testing strategy

The backend should favor tests at the deterministic rules layer first.

Priority order:

1. domain service and policy tests
2. repository tests for persistence adapters
3. thin API tests for route wiring and validation

That fits the repo’s stated preference for deterministic-service confidence over broad automation.

Examples:

- satiety score behavior across meal shapes
- projection outputs across trend scenarios
- progression decisions across workout outcomes
- coaching signal prioritization from conflicting inputs

## Good vs Better vs Best

### Good

Keep the current domain folders, split route files out of `server.ts`, and add validation plus repository seams only where persistence starts.

Why it works:

- lowest migration cost
- keeps momentum
- enough structure for the next few backend slices

### Better

Add a small application layer for multi-step use cases and introduce infrastructure adapters for persistence and AI.

Why it works:

- clearer ownership for cross-domain flows
- easier testing of orchestration
- safer path to a real daily dashboard and persisted logs

### Best

Move to explicit domain modules with policy files, repository interfaces, route modules, and composition-root wiring. Add versioned contracts and read models for dashboard-style endpoints.

Why it works:

- strongest long-term maintainability
- easiest to scale across nutrition, goals, training, and coaching
- best reviewability when rules become more numerous

Why not now:

- the repo is still proving product slices
- too much structure too early would slow iteration

## Recommended next step

The best next move is the `better` option, not the `best` one.

Specifically:

1. Split Fastify routes out of `server.ts`.
2. Add request validation for existing meal endpoints.
3. Introduce a small composition root for service wiring.
4. Add repository seams only for the first persisted flow, likely meal logging and daily dashboard reads.
5. Keep deterministic logic concentrated in domain services and policy helpers.

## Proposed file direction

```text
backend/src/
  app/
    server.ts
    container.ts
    routes/
      healthRoutes.ts
      nutritionRoutes.ts
      goalRoutes.ts
      trainingRoutes.ts
      coachingRoutes.ts
  application/
    nutrition/
      analyzeMeal.ts
      logMeal.ts
    dashboard/
      getDailyDashboard.ts
  contracts/
    mealContracts.ts
    dashboardContracts.ts
    projectionContracts.ts
  domains/
    nutrition/
      models/
      policies/
      services/
      repositories/
    goals/
      models/
      policies/
      services/
      repositories/
    training/
      models/
      policies/
      services/
      repositories/
    coaching/
      models/
      policies/
      services/
      repositories/
  infrastructure/
    persistence/
      inMemory/
    ai/
  shared/
    types.ts
    errors.ts
    auth.ts
```

## Tradeoffs / Considerations

- Adding layers too early can create ceremony. The application layer should be earned, not defaulted.
- Keeping deterministic logic centralized on the backend increases trust, but it means offline parity should be selective and intentional.
- Coaching is the highest-risk area for boundary erosion. Keep deterministic signal selection separate from any AI copy generation.
- The current backend spike is directionally right. The main job now is to preserve that clarity as persistence and orchestration arrive.
