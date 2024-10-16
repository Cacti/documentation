# ESXi/VMWare Template

The ESXi template uses snmp, so ESXi must have SNMP configured correctly.
You can use ESXCLI commands directly on tge host using the ESXi Shell
or via ssh.

```console
esxcli system snmp set --port port
esxcli system snmp set --community community
esxcli system snmp set --enable true
```

You can display actual SNMP settings
```console
esxcli system snmp get
```

---

Copyright (c) 2004-2024 The Cacti Group
