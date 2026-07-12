# ADR-0002: Model installation as durable, resumable install runs

**Status:** Proposed

## Context

The installer currently keeps workflow state in mutable global settings and
mixes wizard rendering with side effects. Background timestamp coordination can
hide failures or permit ambiguous ownership of an install attempt.

## Decision

Installation and upgrade work will be represented by a durable `InstallRun`
with a unique identifier, typed options, plan version, explicit state,
operation checkpoints, lease data, progress, and structured failure details.

The lifecycle is `validating`, `ready`, `running`, `succeeded`, `failed`, or
`cancelled`. State transitions are validated and recorded atomically. A worker
holds a renewable lease for a run and executes one idempotent operation at a
time. Web and CLI interfaces submit commands and render run views; they do not
perform installation work directly.

## Consequences

- Refreshing a wizard page and querying status are side-effect free.
- Failed runs remain failed until an explicit retry or new run is requested.
- Operations can resume from durable checkpoints after interruption.
- Legacy `install_*` settings require a temporary compatibility adapter and a
  documented removal plan.
