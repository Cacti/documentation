# Aggregate Graphs

An **Aggregate Graph** combines series from existing graphs into one graph.
Member graphs must have a compatible graph template so that corresponding items
can be combined consistently. An aggregate uses their data sources; creating it
does not start a separate collection cycle for those measurements.

## Create an aggregate from a template

1. Create an [Aggregate Template](Aggregate-Templates.md) for the common graph
   template and choose its layout, totals and per-item color templates.
2. Under **Console > Management > Graphs**, select the compatible member
   graphs.
3. Choose **Create Aggregate from Template** in the Actions menu, select the
   aggregate template, and review the name and included members before saving.
4. Open the resulting graph and check units, stacking, member order and totals.
   It can be placed on a tree and viewed like other Cacti graphs.

## Maintain members and propagation

Manage the aggregate through **Console > Management > Aggregates**. Review its
member graphs when adding or removing measurements; membership determines the
series contributing to the display and totals.

**Propagation Enabled** keeps the aggregate attached to its template's managed
settings. Template saves update attached aggregates with propagation enabled.
Disabling propagation allows independent settings and detaches template
management; subsequent template edits no longer update that aggregate. Review
this setting when an aggregate does not follow a template change.

[Color Templates](Color-Templates.md) rotate colors across member graphs for
the items to which they are assigned. A legend entry is not an additional
member and does not advance that rotation.

Before a broad synchronization, back up the relevant definitions and verify one
aggregate. Keep source graphs and data-source ownership distinct from aggregate
membership when planning deletion or cleanup.

---
Copyright (c) 2004-2026 The Cacti Group
