# Easier Repo Guide

This repo is the source of truth for the Easier product across iOS, backend, and docs.

## Product stance

- Easier is a goal-driven body recomposition system, not a passive tracker.
- The product loop is `Plan -> Track -> Analyze -> Adjust -> Predict`.
- The core differentiator is helping users hit goals with less hunger and less friction.
- AI explains, estimates, summarizes, and adapts tone.
- Deterministic systems own calculations, projections, satiety scoring, and progression rules.

## Repo shape

- `docs/product`: product specs and user-flow docs
- `docs/architecture`: system design, data flow, API shape, module boundaries
- `ios`: SwiftUI app and modular Swift packages
- `backend`: deterministic services and HTTP contracts

## Local defaults

- Prefer SwiftUI, MV, explicit state ownership, and domain logic in modules instead of views.
- Keep backend services small, deterministic, and easy to test.
- Share contracts through stable JSON shapes, not tight cross-platform coupling.
- Use simple seams first: repositories, services, and focused mappers.
- Avoid protocol spam and speculative abstractions.

## Working agreement

- Start new feature work in docs when the flow or policy is still ambiguous.
- Keep user value, maintainability, and iteration speed visible in tradeoff notes.
- Add tests for deterministic rules before widening UI or AI behavior.
- Treat partial logging as valid success, not failure.

## Validation

- iOS validation should favor focused domain tests before broad UI automation.
- Backend validation should favor unit tests for deterministic services and thin API tests.
- If a command or toolchain is missing, document the gap instead of inventing a workaround.

## Role routing

- `product-tactician`: specs, goals, user flows, acceptance criteria
- `architect`: modules, boundaries, ownership, data flow
- `coder`: implementation
- `code-simplifier`: simplify touched code
- `build-validator`: build, test, lint
- `tester`: test plan and regression coverage
- `pr-helper`: PR title, summary, risk notes
