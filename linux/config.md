# Configuration générale (Fedora 40 Server Edition)
----

## Général

- Stockage : 30Go + 30Go (RAID)
- Root désactivé
- Mot de passe par défault : ""
- Mot de passe (chiffrement) : ""

## Partitionnement

### Les partitions

| Données  |     Type de périphérique     | Système de fichiers | Stockage | Chiffré | Options de montage |
| :--------------- |:---------------:|:-----:|:-----:|:-----:|:-----:|
| /backup  |   **LVM [Fedora]**      |  **xfs** | 4Go | non | defaults, noexec, nosuid, nodev, relatime |
| /home | **RAID 1**| **ext4** | 2Go x 2 | oui | defaults, noexec, nosuid, nodev, relatime |
| /web | **RAID 1**| **ext4** | 3Go x 2 | oui | defaults, noexec, nosuid, nodev, relatime |

| Système  |     Type de périphérique     | Système de fichiers | Stockage | Chiffré | Options de montage |
| :--------------- |:---------------:|:-----:|:-----:|:-----:|:-----:|
| / | **RAID 1** | **xfs** | 4Go x 2 | oui | defaults, nodev |
| /boot | **RAID 1** | **ext4** | 1024Mo x 2| non | defaults, ro, nodev, nosuid, noexec |
| /tmp | **LVM [Fedora]** | **ext4** | 1024Mo | non | defaults, noexec, nosuid, nodev |
| /var | **RAID 1** | **ext4** | 3Go x 2 | oui | defaults, noexec, nosuid, nodev |

### Explications des options de montage

- **noexec** : Empêche l’exécution de fichiers binaires sur cette partition. Utile pour éviter l’exécution de scripts malveillants.
- **nosuid** : Empêche l’escalade de privilèges via les fichiers setuid.
- **nodev** : Empêche la création de périphériques spéciaux sur cette partition.
- **relatime** : Met à jour les timestamps d’accès aux fichiers de manière relative, ce qui peut améliorer les performances sans compromettre la sécurité.
- **ro (read-only)** : Monte la partition en lecture seule pour éviter toute modification accidentelle ou malveillante.

## Plan de sauvegarde Linux
