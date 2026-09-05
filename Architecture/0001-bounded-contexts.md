# ADR-0001: Establish bounded contexts and framework-independent domain code

**Status:** Proposed

## Context

Cacti has grown through a long-lived procedural and class-based codebase.
Several workflows combine HTTP handling, CLI parsing, rendering, persistence,
shell execution, and business rules in the same implementation. This makes
incremental change difficult and exposes internal behavior to plugins.

## Decision

New architectural work will identify bounded contexts and keep their domain
logic framework-independent. Initial contexts include Installation, Plugin
Management, Configuration, Authorization, Data Collection, and Template and
Package Management.

Domain code will use PHP 8.1 value objects, backed enums, aggregates, and
domain exceptions where they make rules explicit. Constructors must not access
the database, filesystem, shell, globals, or request state. Infrastructure,
framework components, and legacy helpers will be accessed through application
services and narrowly defined ports.

## Consequences

- New code can be tested without web, CLI, or database bootstrap.
- Symfony components may implement infrastructure concerns, but Cacti will not
  require a full Symfony application migration.
- Existing code is migrated through adapters; this decision does not require a
  flag-day rewrite.
- Public plugin APIs must depend on stable application contracts, not domain
  internals or legacy globals.
