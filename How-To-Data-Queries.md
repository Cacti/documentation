# How To Work with Data Queries

During the past few weeks as I've made various SNMP Data Query templates I've
ran into a few 'tricks' (which existing user scripts use) to make them work
with most devices. It'd probably be beneficial to publish these in some manner
on the documentation site so others don't have to stumble.

As you already know getting an index is the hardest thing users struggle with.
I've ran across three scenarios and their solutions:

## SNMP index is present

Basically mimic the interface.xml template which comes with Cacti
`(cacti/resource/snmp_queries/interface.xml)`.

SNMPWALK:

```console
Raw OIDs:
.1.3.6.1.2.1.2.2.1.1.1 = INTEGER: 1
.1.3.6.1.2.1.2.2.1.1.2 = INTEGER: 2
.1.3.6.1.2.1.2.1.0 = INTEGER: 2
```

```console
Textual MIB names:
IF-MIB::ifIndex.1 = INTEGER: 1
IF-MIB::ifIndex.2 = INTEGER: 2
IF-MIB::ifNumber.0 = INTEGER: 2
```

In the SNMP XML file, specify the `<oid_index>` and optional
`<oid_num_indexes>` fields. For example:

```XML
<interface>
    <name>Get SNMP Interfaces</name>
    <description>Queries a host for a list of monitorable interfaces</description>
    <oid_index>.1.3.6.1.2.1.2.2.1.1</oid_index>
    <oid_num_indexes>.1.3.6.1.2.1.2.1.0</oid_num_indexes>

    <fields>
        <ifIndex>
            <name>Index</name>
            <method>walk</method>
            <source>value</source>
            <direction>input</direction>
            <oid>.1.3.6.1.2.1.2.2.1.1</oid>
        </ifIndex>
    </fields>
</interface>
```

A verbose query from inside Cacti shows the following:

```shell
+ Running data query [1].
+ Found type = '3' [snmp query].
+ Found data query XML file at 'C:/Inetpub/wwwroot/cacti/resource/snmp_queries/interface.xml'
+ XML file parsed ok.
+ Executing SNMP walk for list of indexes @ '.1.3.6.1.2.1.2.2.1.1'
+ Index found at OID: 'iso.3.6.1.2.1.2.2.1.1.1' value: '1'
+ Index found at OID: 'iso.3.6.1.2.1.2.2.1.1.2' value: '2'
+ Located input field 'ifIndex' [walk]
+ Executing SNMP walk for data @ '.1.3.6.1.2.1.2.2.1.1'
+ Found item [ifIndex='1'] index: 1 [from value]
+ Found item [ifIndex='2'] index: 2 [from value]
```

## SNMP Index is a STRING

Some devices (like on a F5 BigIP) use a STRING to represent the Index due to
the fact it is user configurable. In this case we need Cacti to parse out the
variable length Index.

Sample of a STRING Index:

Raw OID:

```console
.1.3.6.1.4.1.3375.2.2.10.2.3.1.1.5.76.88.87.69.66 = STRING: "LXWEB"
.1.3.6.1.4.1.3375.2.2.10.2.3.1.1.6.69.80.88.87.69.66 = STRING: "EPXWEB"
```

Textual MIB names:

```console
F5-BIGIP-LOCAL-MIB::ltmVirtualServStatName."LXWEB" = STRING: LXWEB
F5-BIGIP-LOCAL-MIB::ltmVirtualServStatName."EPXWEB" = STRING: EPXWEB
```

Next we need to define a OID/REGEXP that will look for the start of the STRING
and create the Index.  In this case the regexp "^.{32}" matches the first 32
characters beginning at the start of the OID -- this is the length of the OID
from the leading dot up to the start of the index. Then the capturing parens
"(.*)" grab the remainder of the OID as a backreference. Use the following SNMP
XML script:

```XML
<interface>
    <name>Get F5 Big-IP Load Balancer Virtual Server Statistics</name>
    <oid_index>.1.3.6.1.4.1.3375.2.2.10.2.3.1.1</oid_index>
        <oid_index_parse>OID/REGEXP:^.{32}(.*)</oid_index_parse>
        <index_order>vsIndex</index_order>
        <index_order_type>alphabetic</index_order_type>

        <fields>
        <vsIndex>
            <name>Index</name>
            <source>index</source>
            <direction>input</direction>
        </vsIndex>
    </fields>
</interface>
```

After creating the Data Query Data & Graph templates in Cacti a verbose query
will spit out the following:

```shell
+ Running data query [20].
+ Found type = '3' [snmp query].
+ Found data query XML file at 'C:/Inetpub/wwwroot/cacti/resource/snmp_queries/f5_bigip_vs.xml'
+ XML file parsed ok.
+ Executing SNMP walk for list of indexes @ '.1.3.6.1.4.1.3375.2.2.10.2.3.1.1'
+ Index found at OID: 'enterprises.3375.2.2.10.2.3.1.1.5.76.88.87.69.66' value: 'LXWEB'
+ Index found at OID: 'enterprises.3375.2.2.10.2.3.1.1.6.69.80.88.87.69.66' value: 'EPXWEB'
+ index_parse at OID: 'enterprises.3375.2.2.10.2.3.1.1.5.76.88.87.69.66' results: '5.76.88.87.69.66'
+ index_parse at OID: 'enterprises.3375.2.2.10.2.3.1.1.6.69.80.88.87.69.66' results: '6.69.80.88.87.69.66'
+ Inserting index data for field 'vsIndex' [value='5.76.88.87.69.66']
+ Inserting index data for field 'vsIndex' [value='6.69.80.88.87.69.66']
```

## SNMP Index does not exist

Some devices do not offer a traditional Index OID to query. Here we need to
create/fake the index for Cacti. This is accomplished once again with a simple
REGEX to split off the last OID (or middle, etc) to create the index for cacti.

SNMPWALK:

Raw OIDs:

```console
.1.3.6.1.2.1.7.1.0 = Counter32: 69367
.1.3.6.1.2.1.7.2.0 = Counter32: 11
.1.3.6.1.2.1.7.3.0 = Counter32: 0
.1.3.6.1.2.1.7.4.0 = Counter32: 64392
```

Textual MIB name:

```console
UDP-MIB::udpInDatagrams.0 = Counter32: 69458
UDP-MIB::udpNoPorts.0 = Counter32: 11
UDP-MIB::udpInErrors.0 = Counter32: 0
UDP-MIB::udpOutDatagrams.0 = Counter32: 64471
```

Consulting the MIB file for these OIDs, we know that the associated index will
always be "0" for each OID.  We'll want to split this off with the
REGEX.

Create the following SNMP XML file:

```XML
<interface>
    <name>Get RFC1213 Stats</name>
    <description>Management Information Base for Network Management of TCP/IP-based internets</description>
    <oid_index>.1.3.6.1.2.1.7.2</oid_index>
    <oid_index_parse>OID/REGEXP:.*\.([0-9]{1,2})$</oid_index_parse>
    <index_order>Index</index_order>
    <index_order_type>alphabetic</index_order_type>

    <fields>
        <Index>
            <name>Index</name>
            <source>index</source>
            <direction>input</direction>
        </Index>
    </fields>
</interface>
```

Once all of the required templates have been created, a verbose query from
Cacti results in the following:

```shell
+ Running data query [23].
+ Found type = '3' [snmp query].
+ Found data query XML file at 'C:/Inetpub/wwwroot/cacti/resource/snmp_queries/RFC1213.xml'
+ XML file parsed ok.
+ Executing SNMP walk for list of indexes @ '.1.3.6.1.2.1.7.2'
+ Index found at OID: 'iso.3.6.1.2.1.7.2.0' value: '11'
+ index_parse at OID: 'iso.3.6.1.2.1.7.2.0' results: '0'
+ Inserting index data for field 'Index' [value='0']
```

## A note on Textual SNMP MIBS and SPINE

Please be aware the SPINE does not parse out textual Mibs.  This means that if
you were to use an OID that contained a string reference rather than numerical
this will cause Graphs to fail as they will not be generated due to spine not
reciving a value at each poll

Example of a bad OID reference for spine:

```shell
interfaces.mib.1.1.1.1.1
```

---
<copy>Copyright (c) 2004-2021 The Cacti Group</copy>
