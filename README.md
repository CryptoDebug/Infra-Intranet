# Projet Intranet - Services Docker

Ce projet met en place une infrastructure intranet avec plusieurs services Docker :
- Keycloak (authentification SSO)
- Nextcloud (stockage de fichiers)
- Grafana (visualisation de données)
- Prometheus (monitoring)
- Nginx (reverse proxy et interface principale)

## Prérequis

- Docker Desktop pour Windows
- Git pour Windows
- Visual Studio Code (recommandé)

## Installation

1. Cloner le repository :
```bash
git clone https://github.com/CryptoDebug/Infra-Intranet
cd Infra-Intranet
```

2. Choisir une méthode de déploiement :

### Méthode 1 : Déploiement rapide
```bash
docker-compose up -d
```

### Méthode 2 : Déploiement avec vérifications (recommandé)
```powershell
.\scripts\deploy.ps1
```
Cette méthode va :
- Vérifier l'installation de Docker
- Configurer automatiquement le fichier hosts
- Lancer les services
- Vérifier que tous les services sont bien démarrés
- Afficher les URLs et identifiants

## Accès aux services

- Interface principale : http://localhost:8081
- Keycloak : http://localhost:8080
- Nextcloud : http://localhost:8081/nextcloud
- Grafana : http://localhost:8081/grafana
- Prometheus : http://localhost:8081/prometheus

## Configuration initiale

### Keycloak
1. Accéder à http://localhost:8080
2. Se connecter avec les identifiants par défaut :
   - Utilisateur : admin
   - Mot de passe : admin
3. Créer un nouveau realm "intranet"
4. Configurer le client "intranet-client"

### Nextcloud
1. Accéder à http://localhost:8081/nextcloud
2. Suivre l'assistant de configuration initiale
3. Configurer l'authentification Keycloak

### Grafana
1. Accéder à http://localhost:8081/grafana
2. Se connecter avec les identifiants par défaut :
   - Utilisateur : admin
   - Mot de passe : admin
3. Configurer la source de données Prometheus

## Structure du projet

```
.
├── config/                 # Fichiers de configuration
│   ├── nginx/             # Configuration Nginx
│   └── monitoring/        # Configuration Prometheus/Grafana
├── css/                   # Styles de l'interface
├── docs/                  # Documentation
│   ├── architecture/      # Documentation d'architecture
│   └── operations/        # Documentation d'exploitation
├── keycloak-realm/        # Configuration Keycloak
├── scripts/               # Scripts d'automatisation
│   └── deploy.ps1        # Script de déploiement
├── docker-compose.yml     # Configuration des services Docker
├── Dockerfile            # Configuration de l'image Nginx
├── hosts                 # Configuration des noms d'hôtes
├── index.html            # Page d'accueil
├── nginx.conf            # Configuration Nginx
└── prometheus.yml        # Configuration Prometheus
```

## Maintenance

### Arrêter les services
```bash
docker-compose down
```

### Redémarrer les services
```bash
docker-compose restart
```

### Voir les logs
```bash
docker-compose logs -f
```

### Mettre à jour les services
```bash
docker-compose pull
docker-compose up -d
```

## Sécurité

- Changez les mots de passe par défaut
- Configurez les rôles dans Keycloak
- Activez l'authentification à deux facteurs si nécessaire
- Mettez en place un pare-feu

## Documentation

Pour plus de détails, consultez :
- [Architecture](docs/architecture/architecture.md)
- [Guide d'exploitation](docs/operations/operations.md)