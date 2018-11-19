# Automatisiertes Aufsetzen von Gitlab-Runner bei AWS
Dieses Repository enthält Terraform-Code zum Aufsetzen eines Gitlab-Runners bei AWS, der sich automatisch bei Gitlab anmeldet. Man muss den Code nicht verstehen, sondern nur diese Anleitung befolgen, um den Runner aufzusetzen.

Der Code fährt eine einzelne EC2-Instanz vom Typ `t2.medium` (konfigurierbar) hoch. Auf dieser wird ein Gitlab Runner vom Typ `docker-executor` gestartet, der durch Docker-in-Docker auch das Bauen von Docker-Images innerhalb einer Gitlab-CI-Pipeline ermöglicht.

Folgende Vorbedinungen müssen für die Nutzung erfüllt sein:
- Man benötigt einen AWS Account. Für diesen muss man einen Access Key erstellt und dessen Credentials unter `~/.aws/credentials` konfiguriert haben.
- Der AWS Account benötigt Rechte bei EC2 zum Verwalten von Instanzen und Security Groups.
- Terraform muss auf dem Rechner installiert sein.

## Variablen spezifizieren
In `inputs.tf` findet man alle Variablen, die definiert werden müssen. In `public.auto.tfvars` sind bereits alle nicht-geheimen Variablen eingestellt. Übrig bleiben `token` und `ssh_private_key_path`, die man in einer `secret.auto.tfvars` zuweisen sollte. Das Token haben wir oben herausgefunden. der `ssh_private_key_path` sollte auf einen privaten SSH-Schlüssel zeigen.

## Token erstellen
Folgende Schritte auf Gitlab ausführen:

1. Repository auswählen
2. Settings -> CI/CD -> Runners
3. Das Token unter "Setup a specific Runner manually" kopieren

## Runner aufsetzen

Man benötigt ein installiertes Terraform und konfigurierte AWS-Credentials, um AWS über Terraform zu nutzen (s.o.).

Dann kann man den Gitlab-Runner bei AWS automatisch mit Terraform aus diesem Ordner wie folgt aufsetzen:

````
terraform init
terraform apply
````

Dann plant Terraform, was zu tun ist, und fragt nochmal, ob es das tun soll. Wenn ihr das bestätigt, setzt Terraform automatisch alles auf. Ihr könnt den Runner anschließend direkt auf der Projektseite sehen und nutzen.

## Runner abräumen
Um den Runner und seine gesamte Infrastruktur abzuräumen, reicht folgender Befehl:

    terraform destroy

## Terraform State Dateien

Terraform speichert den Ist-Zustand der von ihm verwalteten Ressourcen in `terraform.tfstate`. Diese Datei kann und sollte im Git gespeichert werden, solange sie keine Geheimnisse enthält.
