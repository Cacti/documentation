# Servcheck

The Servcheck plugin, shown in Cacti as **Service Monitor**, tests network
services from the Cacti poller and records the result of each test. A test
connects to a service such as a web server, mail server, DNS server, LDAP
directory, file transfer service, MQTT broker, SNMP agent or SSH server,
optionally searches the response for expected text, and records how long the
test took. Servcheck can send an email or run a command when a result changes,
when a test takes too long, or when a certificate is close to expiring.
Administrators who need simple availability checks of services, rather than
graphs of device counters, use this plugin.

## Requirements

- This page documents Servcheck 0.3 (release tag `v0.3`).

- Cacti 1.2.24 or later.

- No other plugin is required. When the **Thold** plugin is installed, a
  test can notify a Thold **Notification List**. When the **Maint** plugin is
  enabled, tests are skipped during matching maintenance schedules.

- The PHP `curl` extension for the HTTP, HTTPS, DNS over HTTPS, LDAP, FTP,
  TFTP, SCP, SMB, MQTT and REST API tests. Without it these tests fail with
  the error `missing php-curl library`.

- The PHP `openssl` extension, which the plugin uses to store credentials
  and to read certificates from mail servers.

- The libcurl library that PHP uses must be built with support for the
  protocols you test. The release README notes that a default libcurl build
  does not include every protocol, for example SMB and LDAP.

## Installation

Install the plugin with the generic procedure in
[Plugin Management](Plugins.md). The plugin directory must be named
`servcheck`. Installing the plugin creates its tables and registers its
poller hook; no configuration file needs to be copied.

After the plugin is enabled, grant the **Service Check Admin** permission to
the users who manage tests, and open **Console > Management > Service
Checker**.

Upgrading from 0.2 to 0.3 changes the database layout. Before the upgrade
converts the data, it copies the tables `plugin_servcheck_test`,
`plugin_servcheck_log` and `plugin_servcheck_proxies` (and
`plugin_servcheck_restapi_method` when it exists) to tables with a `_backup`
suffix. Usernames and passwords stored in tests, proxies and REST API methods
are converted to entries on the **Credential** tab named
`upgrade/convert_test_<id>`, `upgrade/convert_proxy_<id>` and
`upgrade/convert_restapi_<id>`. Back up the Cacti database before upgrading.

## Permissions

Servcheck registers one realm, which covers all of its pages.

###### Table 1. Servcheck realms

| Realm                   | Pages                                                                                                                         |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **Service Check Admin** | `servcheck_test.php`, `servcheck_restapi.php`, `servcheck_credential.php`, `servcheck_curl_code.php`, `servcheck_proxy.php`, `servcheck_ca.php` |

## Settings

Global settings are on **Console > Configuration > Settings > Servcheck**,
in the **Notification Preferences** section.

###### Table 2. Servcheck settings

| Label | Default | Purpose |
| ----- | ------- | ------- |
| **Send Email separately for each address** | Unchecked | Sends a separate email to each recipient address. |
| **Stop sending all notification** | Unchecked | Stops all Servcheck email. Notification can also be turned off for a single test. |
| **Enable Command Execution** | Unchecked | Allows Servcheck to run the **Status Change Command**. |
| **Status Change Command** | Empty | Path of a command to run when a test result, search result or certificate expiration result changes. The command must not include arguments. |
| **Certificate expiry date advanced notification email** | **1 week in advance** | How many days before a certificate expires to send a notification, from **3 days in advance** to **90 days in advance**, or **Disabled**. |

The **Status Change Command** receives the following environment variables:
`SERVCHECK_TEST_NAME`, `SERVCHECK_EXTERNAL_ID`, `SERVCHECK_TEST_TYPE`,
`SERVCHECK_POLLER`, `SERVCHECK_RESULT`, `SERVCHECK_RESULT_SEARCH` and
`SERVCHECK_CERTIFICATE_EXPIRATION`. The plugin ships `example_script.sh`,
which writes some of these variables to a file. The command's exit status and
output are written to the Cacti log.

## Using Servcheck

All Servcheck pages are reached from **Console > Management > Service
Checker**. The page has the tabs **Tests**, **CA certificates**, **Proxies**,
**Credential** and **Curl return codes**.

### Tests

The **Tests** tab, titled **Servcheck Test Management**, lists every test
with its **Last Check (attempt)**, **Stats (OK/problem)**, **Duration**,
**Triggered**, **Result** and **Search result**. The filter can limit the list
by **Search** text and **State**, and sets the page **Refresh** interval.

Each row has icons to edit the test, enable or disable it, view its log
history, view the last returned data and view its graphs. The **Graphs** view
shows test duration for the last hour, 6 hours, day and week.

The actions menu offers **Delete**, **Disable**, **Enable**, **Duplicate**,
**Clear statistics** and **Clear log**.

### Creating a test

1. Open **Console > Management > Service Checker** and click the add icon on
   the **Servcheck Test Management** bar.

2. Enter a **Service Check Name**, choose the **Poller** that runs the test,
   and choose the **Type of service**.

3. Enter the **IP Address or DNS name of server**. To use a port other than
   the default for the service, add it after a colon, for example
   `example.com:5000`. To skip DNS resolution, enter an address in **Resolve
   DNS to Address**.

4. Fill in the service settings that apply to the type, such as **Path Part
   of URL**, **DNS Name for Query**, **LDAP Search**, **SNMP OID** or **SSH
   command**, and choose a **Credential**, **Proxy Server** or **CA Chain** if
   the service needs one.

5. Optionally enter a **Response Search String**. Save the test.

The service types available in 0.3 are listed below.

###### Table 3. Servcheck service types

| Category | Types |
| -------- | ----- |
| Web | HTTP plaintext (port 80), HTTPS (port 443) |
| Mail | SMTP, SMTP with STARTTLS, SMTPS, IMAP, IMAP with STARTTLS, IMAPS, POP3, POP3 with STARTTLS, POP3S |
| DNS | DNS plaintext (port 53), DNS over HTTPS (port 443) |
| LDAP | LDAP (port 389), LDAPS (port 636) |
| File transfer | FTP, TFTP file download, SCP file download, SFTP directory listing, SMB and SMBS file download |
| MQTT | MQTT plaintext (port 1883) |
| REST API | Basic HTTP auth, API key auth, OAuth2/Bearer token auth, Cookie based auth |
| SNMP | SNMP get, SNMP walk |
| SSH | SSH command on remote system |

### Test parameters

###### Table 4. Main test fields

| Label | Default | Purpose |
| ----- | ------- | ------- |
| **How many attempts** | 3 | Number of attempts per run. The first successful attempt ends the test. |
| **Enable Service Check** | Checked | Clear the box to stop running the test. |
| **Check Certificate** | Unchecked | Checks the service certificate. |
| **Check and notify Certificate expiration** | Unchecked | Notifies before the certificate expires, using the global advance notice setting. |
| **How Often to Test** | 1 Poller run | Runs the test every Nth poller run, from 1 to 10. |
| **Trigger** | 1 | How many times the service must be down before an alert is sent. |
| **Long duration alert** | 0 | Duration in seconds above which a test counts as long. 0 turns the check off. |
| **Number of duration violations in a row** | 3 | How many long results in a row are needed before a notification is sent. |
| **Email notification** | Checked | Sends email about state, duration and search result changes for this test. |

### Verification strings

A test can search the returned data with three strings:

- **Response Search String** is the text expected in a working response.

- **Response Search String - Maintenance** is checked when the first string
  is not found. If it is found, the service is reported as under maintenance.

- **Response Search String - Failed** is text that identifies a known
  failure. When it is set, the test alerts only if this string is found.

### Notifications

Each test chooses its recipients with **Notification List** (a Thold
notification list), **Notify Accounts** (Cacti users with an email address)
and **Extra Alert Emails** (comma separated). **Notify Format** is `html` or
`plain`. Text in **Notes** is included in the email, and **External ID** is
passed to the status change command.

### Credentials, proxies and certificates

The **Credential** tab stores the accounts that tests and proxies use. The
**Credential type** is one of **Username and password**, the four REST API
methods, **SNMP v1 or v2**, **SNMP v3** or **SSH private key**. The SSH
private key type is labeled as requiring Cacti 1.2.31 or later.

The **Proxies** tab defines web proxies with a **Hostname**, **HTTP Port**
(default 80), **HTTPS Port** (default 443) and optional **Credential**.

Servcheck checks certificates against the bundle in
`plugins/servcheck/cert/ca-bundle.crt`. For a certificate issued by a private
certificate authority, add the CA and intermediate certificates, PEM encoded,
on the **CA certificates** tab and select that **CA Chain** in the test.

The **Curl return codes** tab lists the libcurl error codes for reference.

## How It Collects Data

Servcheck registers a `poller_bottom` hook. At the end of each poller cycle
Cacti starts `poller_servcheck.php` in the background. It selects the enabled
tests assigned to the current poller and starts one `servcheck_process.php`
process per test, with at most 32 running at once.

Each test process skips the test when **How Often to Test** has not yet
elapsed, or when a Maint schedule covers the test. Otherwise it runs up to
**How many attempts** attempts, writes the result to
`plugin_servcheck_log`, updates the test statistics, and sends notifications
or runs the status change command when needed.

When a run finishes, a summary line starting with `SERVCHECK STATS:` is
written to the Cacti log. On the main poller, log rows older than 30 days are
deleted from `plugin_servcheck_log`. The retention period has no setting.

Tests, proxies, credentials and CA certificates are replicated to remote
data collectors, so a test can be assigned to any poller.

## Command-Line Tools

Run the scripts from the Cacti base directory as the poller user.

`poller_servcheck.php` runs all enabled tests for the local poller:

```console
php plugins/servcheck/poller_servcheck.php [--id=N] [--force] [--debug]
```

- `--id` runs only the test with that ID.

- `--force` forces all the service checks to run now.

- `--debug` displays verbose output.

`servcheck_process.php` runs a single test and is the recommended way to
diagnose one:

```console
php plugins/servcheck/servcheck_process.php --id=N --force --debug
```

- `--id=N` is the test ID from the Servcheck database. It is required.

- `--force` runs the test even if it is disabled or set to run less often
  than every poller cycle.

- `--debug` displays verbose output.

Both scripts also accept `--version` and `--help`.

## Troubleshooting

- Run the failing test with `servcheck_process.php --id=N --force --debug`.
  The release README recommends this as the first step.

- `FATAL: You must install php-curl to use this test` means the PHP `curl`
  extension is missing for the PHP binary the poller uses.

- `ERROR: No users to send SERVCHECK Notification for <test>` in the Cacti log
  means the test has no notification list, account or extra address.

- `Notifications are disabled, notification will not send for test <test>`
  means **Stop sending all notification** is checked.

- `WARNING: Servcheck Command for test[...] ... Is either Not found or Not
  executable!` means the **Status Change Command** path is wrong or the file
  is not executable by the poller user.

- A certificate test fails for a certificate from a private certificate
  authority until its CA chain is added on the **CA certificates** tab and
  selected in the test.

- For POP3 and IMAP tests, the release README advises entering a valid
  username and password, because the result can be wrong without them.

## More Information

- [Servcheck plugin repository](https://github.com/Cacti/plugin_servcheck)

- [0.3 README](https://github.com/Cacti/plugin_servcheck/blob/v0.3/README.md)

---

Copyright (c) 2004-2026 The Cacti Group
