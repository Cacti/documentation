# ADR-0003: Provide a versioned plugin extension boundary

**Status:** Proposed

## Context

Plugins need to extend Cacti without depending directly on legacy installer
state, globals, raw persistence, or unstable domain internals. Existing hooks
must remain compatible while the platform evolves.

## Decision

Cacti will introduce a versioned plugin manifest and extension registry.
Plugins will declare identity, compatibility, dependencies, capabilities, and
their supported lifecycle contributions. They will receive typed application
contexts and least-privilege service interfaces.

Installer extensions will contribute pure plan entries and worker-owned,
idempotent operations. Plugin operations are checkpointed by run, plugin,
version, and operation key. Required plugin failures prevent core terminal
success; optional failures follow an explicit policy.

## Consequences

- Plugin authors have a stable compatibility contract and conformance tests.
- Legacy hooks are translated through a compatibility adapter during a
  published deprecation period.
- Plugins cannot mutate install-run state directly.
- Core can report plugin lifecycle failures with plugin and run identifiers
  while redacting secrets.
