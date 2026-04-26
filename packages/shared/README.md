# Shared Package

This folder contains shared contracts and types used across applications.

## Purpose
- Centralize API contracts, schemas, and shared type definitions.
- Keep cross-app interfaces versioned and consistent.

## Ownership boundary
- Owns shared data models and contract definitions only.
- Must not include app-specific UI implementation or worker runtime logic.
- Intended for consumption by both `apps/web` and `apps/worker`.
