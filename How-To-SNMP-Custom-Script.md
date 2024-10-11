# How To Extend snmpd with custom script/data

Some SNMP servers can be extended with custom scripts or programs. The output of the running script can then 
be read using the OID and can therefore be easily used in Cacti. An example is the thermometer on the USB port.
In combination with [Graph a Single SNMP OID](Graph-a-Single-SNMP-OID.md), this is a very simple way to display such data

We will show the procedure for the very extensive Net-SNMP and FreeBSD BSNMPD.

## Linux Net-SNMP
  Simply add a line to /etc/snmpd.conf and restart snmpd
  **> extend test /bin/echo hello**

  Result will be here:
  **> snmpwalk -v2c -c testing 127.0.0.1 nsExtendOutput1**
  ``
  NET-SNMP-EXTEND-MIB::nsExtendOutput1Line."test" = STRING: hello
  NET-SNMP-EXTEND-MIB::nsExtendOutputFull."test" = STRING: hello
  NET-SNMP-EXTEND-MIB::nsExtendOutNumLines."test" = INTEGER: 1
  NET-SNMP-EXTEND-MIB::nsExtendResult."test" = INTEGER: 0``

  For Cacti you need numeric OID, you can use snmptranslate:
  **> snmptranslate -On NET-SNMP-EXTEND-MIB::nsExtendOutput1Line.\"test\"**

  The result is an OID that we can use:
  ``.1.3.6.1.4.1.8072.1.3.2.3.1.1.4.116.101.115.116``


## FreeBSD BNSMPD
  You need install bsnmp-ucd
  **> pkg install bsnmp-ucd**

  Add these lines to /etc/snmpd.config and restart bsnmpd
  begemotSnmpdModulePath."ucd" = "/usr/local/lib/snmp_ucd.so"
  %ucd
  extNames.0 = "first command"
  extCommand.0 = "/path/to/script.sh"
  extNames.1 = "second command"
  extCommand.1 = "/path/to/script.sh param1"

  Name and result of first command have the same intex:
  **> snmpwalk -v2c -c testing 127.0.0.1 .1.3.6.1.4.1.2021.8.1.2.0**
  ``.1.3.6.1.4.1.2021.8.1.2.0 = STRING: first command``

  **> snmpwalk -v2c -c testing 127.0.0.1 .1.3.6.1.4.1.2021.8.1.101.0**
  ``.1.3.6.1.4.1.2021.8.1.101.0 = STRING: 15``

