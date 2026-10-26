# Login Providers

Login Providers are part of the **unreleased Cacti 1.3 development series**.
They replace the older User Domains management interface and support LDAP,
Active Directory, SAML2, and OpenID Connect. For Cacti 1.2, see
[User Domains](User-Domains.md) and [Multiple LDAP/AD
Domains](Settings-Domains.md).

## Create a provider

1. Keep a working local administrator account and an authenticated session
   available while testing.
2. Open **Console > Configuration > Login Providers** and add a provider.
3. Enter a name and choose the **Provider Type**. Select a **User Template**
   with the permissions intended for newly created accounts.
4. Fill in the connection or identity-provider settings for that type.
5. Enable the provider and save it.
6. Under **Console > Configuration > Settings > Authentication**, select
   **Login Providers** as the authentication method and save.
7. Test a permitted account and a denied account in a new private browser
   session. Confirm the resulting Cacti permissions before wider use.

LDAP and Active Directory providers use credentials entered on the login page.
SAML2 and OpenID Connect providers use redirect-based login buttons. The
**Login Button Label** customizes the button text for those redirect providers.
Local accounts remain available through the local login realm.

## LDAP and Active Directory

Configure the server, ports, protocol version, encryption, and search or bind
settings. Use the [LDAP guide](Settings-Auth-LDAP.md) for the meaning of DN,
search modes, and group membership checks. On the development branch, configure
these values on the provider rather than in the older User Domains screen.

Use TLS with a trusted server certificate. If access should be restricted to
a directory group, configure and test that membership requirement; merely
naming a provider after an administrative group does not restrict access.

For one-time-password authentication, follow the server field's guidance: a
space-delimited list can retry a consumed code against another server. Use a
single resilient endpoint where directory failover happens below Cacti.

## SAML2

Configure the service-provider entity ID and the identity provider's entity
ID, single sign-on URL, and signing certificate. Configure signing options and
service-provider certificate and private key as required by your identity
provider. Exchange the Cacti service-provider metadata with the identity
provider and register its assertion-consumer endpoint.

Map the username, full-name, and email attributes to those actually sent by
the identity provider. Configure the group attribute and required group when
restricting membership. Treat certificates, private keys, and identity claims
as configuration that must be verified with the identity-provider administrator.

## OpenID Connect

Register Cacti as a client with the identity provider. Enter its client ID,
client secret, HTTPS discovery URL, and scopes. The implementation uses the
authorization-code flow with PKCE. Discovery and the returned authentication
endpoints must use HTTPS.

Set Cacti's **Server Base URL** to its externally reachable URL, including its
installation path. The redirect URI is that base URL followed by
`/login_sso.php?action=callback&realm=REALM`, where `REALM` is 1000 plus the
saved provider ID. Register that exact URI with the identity provider.

Map the username, full-name, and email claims. Configure the group claim and
required group if access must be limited to particular users.

## Permissions, cookies, and troubleshooting

A successful identity-provider login does not grant unrestricted Cacti access.
Review the template user, Cacti user groups, and resulting object permissions.
Where automatic group assignment is configured, test both membership and
removal cases. SAML2 and OpenID Connect assignment requires the corresponding
group attribute or claim.

Persistent login requires HTTPS, the global **Support Authentication Cookies**
setting, and the provider's **Allow "Remember Me" Cookies** option. Disable the
provider option where every new session must return to the identity provider.

Use provider debug logging temporarily while diagnosing failures, then disable
it. Check the [Cacti log](Cacti-Log.md), callback URL, clock synchronization,
certificate trust, claim mappings, and group restrictions. Remove sensitive
information before sharing logs.

---

Copyright (c) 2004-2026 The Cacti Group
