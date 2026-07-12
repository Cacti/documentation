# Architecture Decision Records

Architecture Decision Records (ADRs) capture decisions that guide Cacti's
long-term architecture. They are concise, reviewable documents rather than
implementation plans.

## Status values

- **Proposed**: under review and not yet binding.
- **Accepted**: approved for new work.
- **Superseded**: replaced by a later ADR.

## Decisions

1. [ADR-0001: Establish bounded contexts and framework-independent domain code](Architecture/0001-bounded-contexts.md)
2. [ADR-0002: Model installation as durable, resumable install runs](Architecture/0002-durable-install-runs.md)
3. [ADR-0003: Provide a versioned plugin extension boundary](Architecture/0003-plugin-extension-boundary.md)
4. [ADR-0004: Persist workflow state separately from diagnostic artifacts](Architecture/0004-workflow-storage-and-observability.md)

## Contributing

New ADRs should describe the context, decision, consequences, and links to
the implementation work. An ADR does not replace user, operator, or API
documentation.
