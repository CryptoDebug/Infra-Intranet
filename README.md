# Projet Intranet d'Entreprise

## Description
Ce projet consiste en la mise en place d'un intranet d'entreprise complet avec gestion des utilisateurs, partage de fichiers, et monitoring.

## Architecture

### Composants
- **Serveur LDAP** : OpenLDAP pour la gestion des utilisateurs
- **Serveur Web** : Apache/Nginx pour héberger les applications
- **Serveur de Fichiers** : Samba pour le partage de fichiers
- **Base de Données** : MySQL/PostgreSQL
- **Monitoring** : Prometheus + Grafana
- **Reverse Proxy** : Nginx

### Services
- Portail d'accès unifié (Nextcloud)
- Gestion de fichiers (Samba)
- Annuaire (OpenLDAP)
- Monitoring (Prometheus + Grafana)
- Sauvegarde (Bacula)

## Structure du Projet
```
.
├── docs/                    # Documentation
│   ├── architecture/        # Documentation d'architecture
│   └── operations/         # Documentation d'exploitation
├── config/                 # Fichiers de configuration
│   ├── ldap/              # Configuration OpenLDAP
│   ├── samba/             # Configuration Samba
│   ├── nginx/             # Configuration Nginx
│   └── monitoring/        # Configuration Prometheus/Grafana
└── scripts/               # Scripts d'automatisation
```

## Prérequis
- Docker et Docker Compose
- Git
- Accès root/sudo sur les serveurs