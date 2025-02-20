# Script d'énumération de l'attribut "msDS-KeyCredentialLink"

Ce script PowerShell permet d'énumérer les utilisateurs et les ordinateurs d’un domaine Active Directory qui possèdent l'attribut msDS-KeyCredentialLink. Le rapport généré liste, pour chaque objet, les informations extraites du blob KeyCredentialLink telles que le KeyID, l'usage, la source et le DeviceID.

L'article détaillant l'utilisation de ce script est consultable ici : !FIXME_URL!

[Ce script est grandement inspiré d'un script de microsoft](https://learn.microsoft.com/fr-fr/troubleshoot/windows-server/support-tools/script-to-view-msds-keycredentiallink-attribute-value)

### ⚙️ Utilisation du script

```
PS > .\audit-msDS-KeyCredentialsLink.ps1
Le rapport est consultable ici : C:\temp\KeyCredentialLink-report.txt

PS > cat C:\temp\KeyCredentialLink-report.txt

Report généré le 02/20/2025 13:01:43
==== Énumération des Utilisateurs ====
[...]

==== Énumération des Ordinateurs ====
===========
Computer: aisicomputer
DN: CN=aisicomputer,CN=Computers,DC=aisi,DC=local
KeyCredialLink Entries:
   Source|Usage|DeviceID                            |KeyID
   -------------------------------------------------------------------
   AD    |NGC  |e29e9c73-5861-6178-1d77-20c044e974cb|052CA152567B180F7E596F803AC990FEB5077BB39028B632FCD56BE181677AE3
```

