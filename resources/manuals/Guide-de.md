# Cacti installieren und betreiben

Diese Anleitung ersetzt den historischen deutschen Beitrag für neue
Installationen. Sie beschreibt Cacti 1.3 aus dem Entwicklungszweig `develop`,
keine veröffentlichte Version. Für Cacti 1.2 gilt das
[Handbuch des Zweigs 1.2.x][stable]. Der deutsche Einstieg ist neu verfasst;
der vollständige Anhang enthält die aktuellen englischen Kapitel. Dies ist
keine vollständige deutsche Übersetzung des Handbuchs.

## Version und Plattform auswählen

Prüfen Sie vor der Installation die [Systemanforderungen][requirements].
Verwenden Sie ein unterstütztes, aktualisiertes Betriebssystem sowie eine
passende PHP-Version und Datenbank. Die Mindestversionen hängen vom gewählten
Cacti-Zweig ab. Die PHP-Konfiguration für die Kommandozeile und den Webserver
muss getrennt geprüft werden.

Für Linux wählen Sie die Anleitung für [Ubuntu/Debian][debian] oder
[Enterprise Linux][linux]. Verwenden Sie die Anleitung für Ihren Webserver;
Apache und nginx benötigen unterschiedliche Konfigurationen. Für FreeBSD
beachten Sie die [Paket-, Pfad- und PHP-Flavor-Hinweise][install]. Ein Paket
für Cacti 1.2 wird durch die Installation nicht zu Cacti 1.3.

## Installation vorbereiten

Sichern Sie eine vorhandene Datenbank, Konfiguration und die RRD-Dateien.
Testen Sie die Wiederherstellung vor einem Versionswechsel. Installieren Sie
PHP, Datenbank, RRDtool und Net-SNMP nach der gewählten Plattformanleitung.
Verwenden Sie für einen Quellcode-Checkout die mitgelieferte
Composer-Lockdatei:

```sh
composer install --no-dev
composer check-platform-reqs --no-dev
php --ini
php -m
```

Führen Sie Composer als Besitzer der Installation aus. Brechen Sie bei einem
fehlgeschlagenen Plattformtest ab. Importieren Sie `cacti.sql` ausschließlich
in eine neue Datenbank. Die Datenbank einer vorhandenen Installation wird
über den vorgesehenen Upgrade-Prozess aktualisiert.

## Webzugriff und Datensammlung einrichten

Tragen Sie die tatsächlichen Datenbankparameter in `include/config.php` ein.
Schützen Sie diese Datei und den Anwendungscode vor Schreibzugriffen durch
den Webserver. Der Poller benötigt Schreibrechte auf seine
Laufzeitverzeichnisse,
aber keine Administratorrechte. Verwenden Sie HTTPS und beschränken Sie den
Zugriff während der Installation. Schließen Sie alle Prüfungen im Webinstaller
ab und ändern Sie die anfänglichen Zugangsdaten.

Richten Sie genau einen Zeitplan mit den absoluten Pfaden zu PHP und
`poller.php` ein. Benutzer, Intervall und Pfade müssen zur Installation passen.
Starten Sie keinen zweiten Poller parallel. [Spine][spine] ist optional;
verwenden Sie nur eine zu Cacti passende Version.

## Erstes Gerät und Diagramme

Fügen Sie unter **Console > Devices** ein Gerät mit der passenden Vorlage
hinzu. Konfigurieren Sie die tatsächlich am Gerät erlaubte SNMP-Version und
die Zugangsdaten. Begrenzen Sie den SNMP-Zugriff auf den Collector. Erstellen
Sie die gewünschten Diagramme und ordnen Sie sie einem Baum zu. Warten Sie
mehrere Polling-Intervalle, bevor Sie fehlende Messwerte beurteilen.

![Beispieldiagramm mit historischen Messwerten](../../images/graphs-edit.png)

Das Bild zeigt historische Beispieldaten und eine ältere Benutzeroberfläche.
Die aktuelle Schrittfolge steht in [How to Graph Your Network][graphs].

## Fehler untersuchen und aktualisieren

Prüfen Sie zuerst Uhrzeit, Dienststatus, PHP-Konfiguration, ausführbare Pfade,
Dateirechte und das Cacti-Protokoll. Verwenden Sie [Data Source
Debugging][debug]
für eine einzelne Datenquelle. Aktivieren Sie ausführliche Protokollierung
nur gezielt und vorübergehend. Leere Diagramme rechtfertigen weder die
Neuinitialisierung der Datenbank noch das Löschen von RRD-Dateien.

Lesen Sie vor Updates die Versionshinweise und [Upgrade-Anleitung][upgrade].
Sichern Sie externe Datenpfade, Plugins und Cron-/Dienstkonfigurationen.
Verwenden Sie eine Testumgebung und führen Sie die Datenbankaktualisierung
nur einmal aus. [Härtung][hardening] gehört zur Inbetriebnahme.

[stable]: https://github.com/Cacti/documentation/blob/1.2.x/README.md
[requirements]: ../../Requirements.md
[install]: ../../General-Installing-Instructions.md
[linux]: ../../Install-Under-Enterprise-Linux-LAMP.md
[debian]: ../../Installing-Under-Ubuntu-Debian.md
[spine]: ../../Spine.md
[graphs]: ../../How-to-Graph-Your-Network.md
[debug]: ../../Data-Debug.md
[upgrade]: ../../Upgrading-Cacti.md
[hardening]: ../../Hardening-Cacti-Installation.md
[windows]: ../../Installing-Under-Windows.md
[windows-upgrade]: ../../Upgrading-Cacti-Under-Windows.md

---

Copyright (c) 2004-2026 The Cacti Group
