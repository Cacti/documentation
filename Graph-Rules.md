# Automation Graph Rules

This section will describe **Graph Rules** in Cacti.

Graph rules are used by the Cacti automation process after a device has been identified and a template has been applied
the next step is graph creation. Graph rules are processed top to bottom.

The graph rule matches the graph template tby looking at the data fields chosen that are avaliable in the data query
for example below we are creating graphs for interface traffic the data query has several fields avaliable to match on 

![Automation Graph Rules](images/automation-graph-rules.png)

A practical example if you want to create graphs for interfaces that are in up/up status you would choose the ifOperstatus field and match
the status to UP this would tell automation to create the graph for that interface only if the data query discovers the operational status is equal
to up.

![Automation Graph Rules Edit](images/automation-graph-rules-edit1.png)

![Automation Graph Rules Device Criteria](images/automation-graph-rules-edit2.png)

![Automation Graph Rules Graph Criteria](images/automation-graph-rules-edit3.png)

![Automation Graph Rules Matching Devices](images/automation-graph-rules-edit4.png)

![Automation Graph Rules Matching Objects](images/automation-graph-rules-edit5.png)

---
Copyright (c) 2004-2021 The Cacti Group
