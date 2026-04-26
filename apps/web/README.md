# Web App

This folder contains the web UI application for the Shorts Creator platform.

## Purpose
- Provide user-facing workflows for uploads, clip review, and approvals.
- Display pipeline status, candidate clips, and render outputs.

## Ownership boundary
- Owns browser UX, frontend routing, and client-side state.
- Must not contain pipeline execution logic or worker orchestration code.
- Consumes shared contracts/types from `packages/shared`.
