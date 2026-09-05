# ADR-0004: Persist workflow state separately from diagnostic artifacts

**Status:** Proposed

## Context

Installer state, progress, and diagnostics are currently spread across global
settings and logs. This makes recovery, support, retention, and secret
redaction difficult to reason about.

## Decision

Relational storage is the source of truth for install runs, operation
checkpoints, leases, and structured events. Each record is scoped to a run ID
and uses atomic state and lease updates. Verbose logs, support bundles, and
large generated artifacts are stored separately with metadata and checksums in
the relational store.

Run options, checkpoints, and events are schema-versioned and validated.
Secrets are not copied into run records, events, logs, or artifacts; protected
configuration stores secret values and workflow records retain only references
or redacted values.

## Consequences

- Operators can diagnose a run without reconstructing state from global logs.
- Retention can prune successful details while preserving failed-run evidence.
- Plugin operation data can use generic namespaced checkpoints instead of
  creating arbitrary installer-state tables.
- Storage migrations, indexing, artifact cleanup, and retention policy are
  required parts of the implementation.
