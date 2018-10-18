# Automatisiertes Aufsetzen von Gitlab-Runner bei AWS
Dieses Repository enthält Terraform-Code zum Aufsetzen eines Gitlab-Runners bei AWS, der sich automatisch bei Gitlab anmeldet. Man muss den Code nicht verstehen, sondern nur diese Anleitung befolgen, um den Runner aufzusetzen.

Der Code fährt eine einzelne EC2-Instanz vom Typ `t2.medium` (konfigurierbar) hoch. Auf dieser wird ein Gitlab Runner vom Typ `docker-executor` gestartet, der durch Docker-in-Docker auch das Bauen von Docker-Images innerhalb einer Gitlab-CI-Pipeline ermöglicht.

Folgende Vorbedinungen müssen für die Nutzung erfüllt sein:
- Man benötigt einen AWS Account. Für diesen muss man einen Access Key erstellt und dessen Credentials unter `~/.aws/credentials` konfiguriert haben.
- Der AWS Account benötigt Rechte bei EC2 zum Verwalten von Instanzen und Security Groups.
- Terraform muss auf dem Rechner installiert sein.

## Variablen spezifizieren
In `public.tfvars` sind alle nicht-sensiblen Variablen eingestellt. Insbesondere `gitlab_server` und `ssh_key_name` sollten angepasst werden.

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
terraform apply -var-file="public.tfvars"
````

Terraform fragt dann noch nach den Variablen `token` und `ssh_private_key_path`. Ersteren haben wir oben herausgefunden. Letzterer sollte auf unseren privaten SSH-Schlüssel zeigen. Ihr findet ihn in unserer Keepass-Datei.

Dann plant Terraform, was zu tun ist, und fragt nochmal, ob es das tun soll. Wenn ihr das bestätigt, setzt Terraform automatisch alles auf. Ihr könnt den Runner anschließend direkt auf der Projektseite sehen und nutzen.

## Runner abräumen
Um den Runner und seine gesamte Infrastruktur abzuräumen, reicht folgender Befehl:

    terraform destroy -var-file="public.tfvars"

Weitere Variablen müssen wieder angegeben werden. Ihr könnt aber auch falsche Werte angeben, da diese beim Abräumen eh irrelevant sind. Nur bei `ssh_private_key_path` muss ein gültiger Dateipfad angegeben werden. Das kann aber der einer beliebigen Datei sein.

## Terraform State Dateien

Terraform speichert den Ist-Zustand der von ihm verwalteten Ressourcen in `terraform.tfstate`. Diese Datei kann im Git gespeichert werden, solange sie keine Geheimnisse enthält.
