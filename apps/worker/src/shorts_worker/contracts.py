"""Shared job-kind constants mirrored from packages/shared contracts."""

from typing import Literal

JobKind = Literal["ingest", "transcribe", "score", "render"]
VALID_JOB_KINDS: set[str] = {"ingest", "transcribe", "score", "render"}
