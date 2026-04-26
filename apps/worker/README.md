# Worker App

This folder contains the Python pipeline worker for media processing and AI-assisted clip generation.

## Purpose
- Run background jobs for ingest, transcription, scoring, and rendering.
- Execute deterministic media pipeline steps and task retries.

## Ownership boundary
- Owns server-side job execution and media processing pipeline code.
- Must not contain web UI components or browser-specific logic.
- Uses shared contracts/types from `packages/shared` for job and data interoperability.
