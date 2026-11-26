# Credentials

The Credentials plugin is a central store for the credentials that Cacti
administrators and plugin authors need, such as SNMP communities, SSH logins,
API tokens and database accounts. A secret is either encrypted in the Cacti
database or fetched at poll time from an external secret store. Other plugins
read a stored credential with one function call, `credentials_get()`.

This page follows the plugin's `main` branch, which is unreleased and can
change. In its `INFO` file that branch declares version 1.1 and compatibility
with Cacti 1.2.29. Check the release you install for differences.

## Requirements

- Cacti 1.2.29 or later, as declared in the `INFO` file. The `INFO` file lists
  no required plugins.
- PHP `openssl`, used for encryption of stored secrets (`openssl_encrypt()`)
  and for signing requests to Google Cloud Secret Manager.
- PHP `curl` for the external secret providers. The provider code stops with an
  error when `curl_init()` is not available.
- A Cacti secret encryption key. The plugin stores secrets through Cacti's
  secret functions. Saving a secret fails with an error message when those
  functions are unavailable or the key cannot be used.

## Installation

Follow the generic steps in [Plugin Management](Plugins.md). The plugin
directory must be named `credentials`. Installing creates the `credentials` and
`credential_providers` tables. Upgrading adds the `provider_id` column and index
to the `credentials` table when they are missing. Uninstalling does not remove
the tables.

The pages are added to the Configuration menu after **User Domains**, or after
**Login Providers** when that entry exists.

## Permissions

The plugin registers no realm of its own. The pages `credentials.php` and
`credential_providers.php` are mapped to the core realm 1, the
permission that governs user and group administration. The code comments call
it the core Users/Groups permission. A user who has it can manage credentials
and secret providers.

## Settings

The plugin has no tab under **Console > Configuration > Settings**. Everything
is configured on its two pages, **Credentials** and **Secret Providers**, both
under **Console > Configuration**.

## Using Credentials

### Credentials

Open **Console > Configuration > Credentials**. The screenshot shows the list
with five synthetic credentials of different types. Four are held in the local
database and one uses a provider.

![Credentials list with five synthetic credentials][credentials-image]

The list has a **Search** box, a **Type** filter and a **Credentials** row
count. Its columns are **Name**, **Type**, **Secret Provider**, **Description**,
**Owner**, **Enabled** and **Last Updated**. The actions menu on the list offers
**Delete**, **Enable** and **Disable** for the selected credentials.

To add a credential:

1. Click the plus icon at the top right of the list.
2. Enter a **Name**, which must be unique, and an optional **Description**.
3. Choose a **Credential Type**. The form fields below change with the type.
4. Choose a **Secret Provider**: the local encrypted database, or one of the
   providers you configured.
5. Fill in the type's fields and click **Save**.

Secret fields are encrypted when stored and are not sent back to the browser.
When a value is stored, the form says "A value is currently stored
(encrypted)". Leave the field blank to keep it or enter a new value to replace
it. With an external provider, each secret field holds a reference that the
provider resolves at poll time, and its label shows the provider's reference
name, for example **Secret Path and Key** for HashiCorp Vault.

Changing the type of an existing credential asks for confirmation, because the
values stored for the old type are discarded when you save.

The plugin supports 14 credential types:

| Group | Types |
| --- | --- |
| Core polling | SNMP v1/v2c Community, SNMP v3 (USM), Username / Password, SSH |
| API and cloud | Bearer / API Token, API Key, GitHub Personal Access Token, OAuth 2.0 Client Credentials, HTTP Basic Auth |
| Extended devices | WMI (Windows), IPMI / Redfish (BMC), Database, VMware / vCenter, TLS Client Certificate |

For example, SNMP v1/v2c Community has **SNMP Version**, **Read Community** and
**Write Community**. SNMP v3 (USM) has **Security Name**, **Authentication
Protocol**, **Authentication Passphrase**, **Privacy Protocol**, **Privacy
Passphrase**, **Context Name** and **Engine ID**. The field definitions are in
`includes/arrays.php` in the plugin.

### Secret providers

Open **Console > Configuration > Secret Providers**. The list has the columns
**Name**, **Type**, **Description**, **Enabled** and **Last Updated**, and the
same **Delete**, **Enable** and **Disable** actions. A provider that is still
used by a credential is not deleted.

To add a provider:

1. Click the plus icon.
2. Enter a **Name** and **Description**, and choose a **Provider Type**.
3. Fill in the connection fields, which depend on the type. Connection secrets
   such as tokens and keys are encrypted like credential secrets.
4. Click **Save**, then **Test Connection** to check connectivity and
   authentication. A provider must be saved before it can be tested.

The provider types are HashiCorp Vault, OpenBao, AWS Secrets Manager, Azure Key
Vault, Google Cloud Secret Manager and CyberArk Conjur. You can add any number
of instances of each type.

### Reading a credential from code

`credentials_get($id)` is declared in
`plugins/credentials/includes/functions.php`. It returns an array with the
credential's `name`, `description`, `type`, `provider_id`, `user_id`, `enabled`
and a `fields` array keyed by the type's field names, with secrets decrypted or
resolved through the provider. It returns `false` when the credential does not
exist.

```php
require_once $config['base_path'] . '/plugins/credentials/includes/functions.php';

$credential = credentials_get($credential_id);

if ($credential === false) {
    cacti_log('Credential not found');
    return;
}
```

## Troubleshooting

- "Cannot store a secret: the Cacti core secret encryption functions are
  unavailable on this installation." appears when encryption is not available
  on the Cacti installation.
- "Could not encrypt the secret. Verify the Cacti encryption key configuration
  and try again." means encryption failed. The Cacti log then has a line that
  starts with `ERROR: CREDENTIALS - secret encryption failed`.
- "The selected secret provider is disabled." and "The selected secret
  provider does not exist." appear when you save a credential that points to a
  provider that is disabled or gone.
- "Save the provider before testing it." appears when you use **Test
  Connection** on an unsaved provider.

## More Information

- [Credentials repository](https://github.com/Cacti/plugin_credentials)
- [Credentials README][readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[credentials-image]: images/plugin-credentials-list.png
[readme]: https://github.com/Cacti/plugin_credentials/blob/main/README.md

---

Copyright (c) 2004-2026 The Cacti Group
