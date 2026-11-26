# Service Check

Servcheck monitors network services from Cacti. An administrator defines a
service check, chooses a service type (HTTP, mail, DNS, LDAP, FTP, SNMP, SSH
and others), optionally gives a string that a healthy response must contain,
and Servcheck runs the check on every poller cycle, records the result and
connection statistics, and sends email when the state changes, a certificate
is about to expire, or a check is slow. It is for administrators who want
service-level checks beside device monitoring. The plugin is based on the
Webseer plugin and has its own menu entry and tables.

This page follows the plugin's `main` branch, which is unreleased and can
change. The branch declares version 0.4 and Cacti compatibility 1.2.29 in its
`INFO` file. Its display name in `INFO` is Service Monitor, and its menu entry
is **Service Checker**. Do not treat this page as a description of a released
version.

## Requirements

- Version 0.4 and Cacti 1.2.29 or later, as declared in `INFO`.
- The PHP cURL library for the cURL based checks (HTTP, HTTPS, mail, LDAP,
  FTP, SCP, SMB, MQTT, DNS over HTTPS and REST). The README notes that a
  default libcurl build does not compile in every service, so protocols such
  as SMB and LDAP can need a libcurl built with them.
- Cacti's SNMP functions for the **SNMP get** and **SNMP walk** types. The
  **SSH command** and **SFTP** types use the phpseclib 3 library classes.
- The OpenSSL PHP extension, which the plugin uses to store credentials in
  encrypted form.
- The Maintenance (`maint`) plugin is optional. When it is enabled, Servcheck
  skips tests that have an active maintenance schedule.
- The `INFO` file declares remote collection support. Tests, credentials,
  proxies and CA chains are replicated to remote pollers.
- The PHP binary path from Cacti's **Paths** settings, which the poller uses
  to start the check processes. If it is empty, `php` is used.

## Installation

Follow the generic steps in [Plugin Management](Plugins.md), installing the
plugin in `plugins/servcheck`. Grant the **Service Check Admin** realm to the
users who manage checks, then open **Console > Management > Service Checker**.

When you upgrade the plugin files, restart the Servcheck background process:
`poller_servcheck.php` runs for a while and keeps the old code in memory.
Stop the running `poller_servcheck.php`, and Cacti's poller starts it again on
the next cycle. On upgrade the plugin also removes its own development-only
files, such as the `tests` directory.

On Cacti releases below 1.2.31, the Cancel buttons on forms need a click
binding for the `cactiReturnTo` class in `include/layout.js`. The README has
the snippet.

Uninstalling the plugin drops its tables, including all tests and logs.

## Permissions

The plugin registers one realm in `setup.php`.

| Realm | Pages covered |
| --- | --- |
| Service Check Admin | `servcheck_test.php`, `servcheck_credential.php`, `servcheck_curl_code.php`, `servcheck_proxy.php`, `servcheck_ca.php` |

## Settings

Settings are on the **Servcheck** tab of **Console > Configuration >
Settings**.

### Notification Preferences

| Setting | Default | Purpose |
| --- | --- | --- |
| **Send Email separately for each address** | off | Send each email separately for each address. |
| **Stop sending all notification** | off | Servcheck sends no email at all. Notification can also be turned off for a single test. |
| **Enable Command Execution** | off | Allow running a command on Servcheck events. Each test can opt in or out. |
| **Status Change Command** | empty | Command to run when a basic, search or certificate expiration test returns a different result. It cannot have command line arguments. The test details are passed in environment variables such as `SERVCHECK_TEST_NAME`, `SERVCHECK_EXTERNAL_ID` and `SERVCHECK_TEST_TYPE`. |
| **Concurrent Check Processes** | 8 | Number of service check processes to run at the same time. The description advises against going above twice the number of cores. |
| **Certificate expiry date advanced notification email** | 7 | Days before certificate expiry to send a notice. Choices are Disabled, 3 days, 1 week, 3 weeks, 30, 60 or 90 days. |
| **Certificate expiry notification email interval** | 10 | Days between expiry notices. After the expiry date, the notice is sent every day. |
| **How long to keep logs** | see note | Age after which older logs are deleted: Never, 24 hours, 7 days, 90 days, 180 days or 1 year. |
| **Maximum test duration in seconds** | 3 | Default for tests that do not use a duration threshold. With a threshold, the maximum is the threshold plus 2 seconds. |

The code gives **How long to keep logs** a default of 8, which is not one of
the listed choices. Select a value explicitly.

### HTTP/HTTPS Check Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| **User Agent** | a current desktop browser string | User-Agent sent with HTTP, HTTPS and other cURL based checks. Leave blank to use the built-in default. |

## Using Service Check

Open **Console > Management > Service Checker**. The page has five tabs:
**Tests**, **CA certificates**, **Proxies**, **Credential** and **Curl return
codes**.

The following screenshot shows the **Tests** tab with synthetic data: one test
that is disabled, one in error and several healthy ones, with their last check,
statistics, duration, trigger state and result.

![Test list with synthetic tests in several states][img-servcheck-tests]

The list has a regular expression search and **State**, **Refresh** and
**Checks** filters. The status colors are Error, Long duration, Warning,
Failing, Ok and Disabled. Each row has icons to edit the test, enable or
disable it, view its history, view the last returned data and view its graph.
Bulk actions are **Delete**, **Disable**, **Enable**, **Duplicate**, **Clear
statistics** and **Clear log**.

### Add a service check

1. On the **Tests** tab, add a test.
2. Under **General Settings**, set **Service Check Name**, **How many
   attempts** (default 3), **Enable test** (default on), **Enable run script
   for this test** (default on) and the **Poller**. The first successful
   attempt ends the check. If none succeeds, a failure is recorded.
3. Choose **Type of service**. The types are HTTP and HTTPS, SMTP (plain,
   STARTTLS and SMTPS), IMAP and POP3 (plain, STARTTLS and encrypted), DNS and
   DNS over HTTPS, LDAP and LDAPS, FTP, TFTP, SCP, SMB and SMBS, MQTT, REST API
   with Basic, API key, OAuth2/Bearer or cookie authentication, SNMP get and
   walk, SSH command and SFTP. The page shows the default port of each type.
4. Enter **IP Address or DNS name of server**. Add `:port` to use another port.
   **Resolve DNS to Address** forces a name to resolve to an address that you
   give.
5. Under **Service settings**, fill in the fields that apply to the type. They
   include **Credential**, **SNMP OID**, **SSH command**, **LDAP Search**,
   **DNS Name for Query**, **Path Part of URL**, **Requires Authentication**,
   **Proxy Server**, **Check Certificate** and **Check and notify Certificate
   expiration**. For a custom certificate authority, choose a **CA Chain**.
6. Under **Parameters**, set **How Often to Test** (every N poller runs),
   **Trigger** (how many times the service must be down before an alert),
   **Long duration alert** and **Number of duration violations in a row**.
7. Under **Verification Strings**, set **Response Search String**,
   **Response Search String - Maintenance** and **Response Search String -
   Failed**. The maintenance string marks a response that shows the service is
   under maintenance. The failed string alerts only when it is found.
8. Under **Notification Settings**, set **Email notification** (default on),
   **Notify Format**, **Notification List**, **Notify Accounts**, **Extra Alert
   Emails**, **Notes** and **External ID**.

### Credentials, proxies and CA chains

- **Credential** entries hold the secrets for tests. The credential types are
  username and password, REST API (Basic, API key, OAuth2/Bearer, cookie),
  SNMP v1 or v2, SNMP v3 and SSH private key.
- **Proxies** hold a name, hostname, HTTP port (default 80), HTTPS port
  (default 443) and an optional credential, for tests that need a web proxy.
- **CA certificates** hold a name and a CA chain. Servcheck checks certificates
  against the bundled file of common root certificate authorities. For a
  private authority, upload the whole chain (CA and intermediate
  certificates) and select it in the test.

### Graph template

The `templates` directory contains a data query and script server files for
graphing a test. Copy `servcheck.xml` to the Cacti `resource/script_server`
directory and `ss_servcheck.php` to the Cacti `scripts` directory. Import
`cacti_data_query_servcheck_plugin.xml` from **Console > Import/Export >
Import Templates**, then add the **Plugin Servcheck** data query to the device.

## Background Processing

Servcheck hooks into `poller_bottom` and starts `poller_servcheck.php` in the
background on every poller cycle. The master process registers itself so that
only one copy runs per poller. It then starts up to **Concurrent Check
Processes** `servcheck_process.php` children, each handling a share of the
enabled tests for that poller, and waits for them. A test that is not yet due
(**How Often to Test**) or that has an active maintenance schedule is skipped.

For each test the result, search result, duration, certificate data, cURL
code and the returned data are stored in the log table, and statistics are
updated. Servcheck can send email for these events: a service state change, a
change in the search result, certificate expiration and a long duration. When
**Enable Command Execution** is on, it can also run the **Status Change
Command**.

At the end of a run, the master process writes a `SERVCHECK STATS` line to the
Cacti log. On poller 1, it also deletes log rows older than 30 days. Each
check process additionally applies the **How long to keep logs** setting to
its test.

## Command-Line Tools

Run these as the Cacti poller user.

```console
usage: poller_servcheck.php [--debug] [--force]

--force    - Force all the service checks to run now. Run even if the job is disabled or set to run less frequently than every poller cycle
--debug    - Display verbose output during execution
```

```console
usage:
servcheck_process.php --id=N [--debug] [--force]

or:
servcheck_process.php --process=N [--debug] [--force]

--id=N      - The Test ID from the Servcheck database.
--process=N - This process then processes (total number of tests/max. process) tests.
--force     - Run even if the job is disabled or set to run less frequently than every poller cycle
--debug     - Display verbose output during execution
```

To debug one test, run `servcheck_process.php --id=<ID> --force --debug` from
the plugin directory.

The plugin's `example_script.sh` shows how a **Status Change Command** can use
the test variables.

## Troubleshooting

- A certificate check fails for a certificate from a private authority: add
  the whole chain on the **CA certificates** tab and select it in the test.
- POP3 and IMAP checks return wrong results: enter a correct username and
  password. The README states that without credentials cURL can return an
  incorrect result.
- A protocol such as SMB or LDAP does not work: the libcurl build might not
  include it. The README says libcurl must then be built with it.
- A test is slow or times out: the default maximum duration is 3 seconds.
  Raise **Long duration alert** on the test, remembering that the maximum then
  becomes that value plus 2 seconds.
- A test never runs: check that the test is enabled, that **How Often to
  Test** is not set to a longer interval, and that no maintenance schedule is
  active. Use `--force` to run it now.
- Checks that download files should use small text files, as the README
  recommends.
- Use `servcheck_process.php --id=N --force --debug` to see detailed output of
  one test.
- Only test servers that you are allowed to test.
- If the log shows "Not Running Service Check process N because it is still
  running", a previous child process has not finished yet.

## More Information

- [Servcheck repository](https://github.com/Cacti/plugin_servcheck)
- [Servcheck README][readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[img-servcheck-tests]: images/plugin-servcheck-tests.png
[readme]: https://github.com/Cacti/plugin_servcheck/blob/main/README.md

---

Copyright (c) 2004-2026 The Cacti Group
