# Architecture de l'Intranet d'Entreprise

## Vue d'ensemble

L'intranet d'entreprise est construit avec une architecture moderne basée sur des conteneurs Docker, offrant une solution complète pour la gestion des utilisateurs, le partage de fichiers, et le monitoring.

## Composants

### 1. Keycloak
- **Rôle** : Gestion de l'authentification SSO (Single Sign-On)
- **Configuration** : 
  - Port : 8080
  - Realm : intranet
  - Client : intranet-client
- **Sécurité** : OAuth2/OpenID Connect

### 2. Nextcloud
- **Rôle** : Portail d'accès unifié et partage de fichiers
- **Fonctionnalités** :
  - Partage de fichiers
  - Calendrier
  - Contacts
  - Notes
- **Intégration** : Authentification via Keycloak

### 3. Base de données (MySQL)
- **Rôle** : Stockage des données Nextcloud
- **Configuration** :
  - Base de données : nextcloud
  - Utilisateur dédié avec privilèges limités

### 4. Nginx
- **Rôle** : Reverse proxy et interface principale
- **Fonctionnalités** :
  - Interface d'accès unifié
  - Redirection vers les services
  - Gestion des headers de sécurité
  - Proxy pour les services internes

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
                                    ├── Keycloak (SSO)
                                    ├── Nextcloud
                                    ├── MySQL
                                    └── Monitoring (Prometheus/Grafana)
```

## Sécurité

### 1. Authentification
- Authentification centralisée via Keycloak
- SSO pour tous les services
- Principe du moindre privilège appliqué

### 2. Headers de sécurité
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