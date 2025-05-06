# Architecture de l'Intranet d'Entreprise

## Vue d'ensemble

L'intranet d'entreprise est construit avec une architecture moderne basée sur des conteneurs Docker, offrant une solution complète pour la gestion des utilisateurs, le partage de fichiers, et le monitoring.

## Composants

### 1. OpenLDAP
- **Rôle** : Gestion centralisée des utilisateurs et des groupes
- **Configuration** : 
  - Base DN : dc=monentreprise,dc=local
  - Ports : 389 (LDAP), 636 (LDAPS)
- **Sécurité** : Communication chiffrée via LDAPS

### 2. Nextcloud
- **Rôle** : Portail d'accès unifié et partage de fichiers
- **Fonctionnalités** :
  - Partage de fichiers
  - Calendrier
  - Contacts
  - Notes
- **Intégration** : Authentification via OpenLDAP

### 3. Base de données (MariaDB)
- **Rôle** : Stockage des données Nextcloud
- **Configuration** :
  - Base de données : nextcloud
  - Utilisateur dédié avec privilèges limités

### 4. Nginx
- **Rôle** : Reverse proxy et terminaison SSL
- **Fonctionnalités** :
  - Redirection HTTP vers HTTPS
  - Gestion des certificats SSL
  - Headers de sécurité
  - Load balancing

### 5. Monitoring
- **Prometheus** : Collecte des métriques
- **Grafana** : Visualisation des données
- **Métriques surveillées** :
  - Performance des services
  - Utilisation des ressources
  - Disponibilité des services

## Architecture réseau

```
[Internet] → [Nginx Reverse Proxy] → [Services Internes]
                                    ├── Nextcloud
                                    ├── OpenLDAP
                                    ├── MariaDB
                                    └── Monitoring
```

## Sécurité

### 1. Chiffrement
- TLS 1.2/1.3 pour toutes les communications
- Certificats SSL auto-signés (en production, utiliser Let's Encrypt)

### 2. Authentification
- Authentification centralisée via OpenLDAP
- Principe du moindre privilège appliqué

### 3. Headers de sécurité
- X-Frame-Options
- X-XSS-Protection
- X-Content-Type-Options
- Content-Security-Policy

## Maintenance

### 1. Sauvegardes
- Sauvegardes quotidiennes de la base de données
- Sauvegardes des fichiers Nextcloud
- Rotation des logs

### 2. Monitoring
- Alertes sur les ressources critiques
- Tableaux de bord Grafana pour la surveillance
- Logs centralisés

## Évolutivité

L'architecture est conçue pour être évolutive :
- Possibilité d'ajouter de nouveaux services
- Scalabilité horizontale possible
- Isolation des services via Docker 