# ESXi/VMware Template

The bundled ESXi template polls the ESXi host through SNMP. Configure the
host's SNMP agent and allow the Cacti collector to reach its polling port. Run
ESXCLI as an authorized administrator through the ESXi Shell or SSH.

For an SNMPv2c configuration, inspect the existing settings first:

```console
esxcli system snmp get
```

The following example uses UDP port 161. Replace `REPLACE_WITH_READ_COMMUNITY`
with your chosen community before running it. The `--communities` option
replaces the existing community list; preserve other required communities when
changing an existing configuration.

```console
esxcli system snmp set --port 161
esxcli system snmp set --communities 'REPLACE_WITH_READ_COMMUNITY'
esxcli system snmp set --enable true
```

These options are documented in Broadcom's [ESXCLI command reference][esxcli].
They configure the agent; they do not prove that routing or firewall rules
permit polling. Allow the intended collector to reach the host's SNMP port
using the firewall procedure for your ESXi release.

Check the resulting configuration:

```console
esxcli system snmp get
```

In Cacti's [device settings](Devices.md), select the ESXi template and matching
SNMP version, community and port. Verify the returned queries and graphs from
the assigned collector. Use your ESXi release's SNMPv3 configuration procedure
if required; the community example above does not configure SNMPv3.

[esxcli]:<https://developer.broadcom.com/xapis/esxcli-command-reference/latest/namespace/esxcli_system.html>

---

Copyright (c) 2004-2026 The Cacti Group
