# Easier Subagent Workflows

## Context

This repo is meant to work well with role-based Codex collaboration.

## Problem

Without explicit handoff rules, specs, architecture, implementation, and validation blur together.

## Solution

Route work by the smallest role set needed.

## Output

### Standard feature workflow

1. `product-tactician`
   - clarify the user problem
   - define goals, flows, acceptance criteria, risks
2. `architect`
   - define module boundaries, data flow, and state ownership
3. `coder`
   - implement the narrowest working slice
4. `tester`
   - add domain tests and regression coverage
5. `build-validator`
   - run focused validation
6. `pr-helper`
   - package scope, risk, and testing notes

### Default ownership by task

- Feature spec or scope change: `product-tactician`
- Boundary or model decisions: `architect`
- Screen or service implementation: `coder`
- Complexity cleanup: `code-simplifier`
- Projection, satiety, or progression tests: `tester`
- Build and test runs: `build-validator`

### Guardrails

- Do not put domain policy in SwiftUI views.
- Do not use AI for projections, calorie calculations, satiety scoring, or workout progression rules.
- Keep AI outputs textual or structured-estimation only.
- Add docs first when the behavior is still ambiguous.

## Tradeoffs / Considerations

- This adds a little process overhead up front.
- It pays back quickly by keeping a health product’s trust boundaries explicit.
