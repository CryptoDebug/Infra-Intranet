# Guide d'Exploitation de l'Intranet

## Démarrage rapide

### Prérequis
- Docker Desktop pour Windows
- Git pour Windows
- Visual Studio Code (recommandé)

### Installation

1. Cloner le dépôt :
```bash
git clone https://github.com/CryptoDebug/Infra-Intranet/
cd Infra-Intranet
```

2. Configuration du système :
   - Ajouter les entrées suivantes dans `C:\Windows\System32\drivers\etc\hosts` :
   ```
   127.0.0.1 nextcloud.monentreprise.local
   127.0.0.1 grafana.monentreprise.local
   127.0.0.1 prometheus.monentreprise.local
   127.0.0.1 keycloak.monentreprise.local
   ```

3. Lancer les services :
```bash
docker-compose up -d
```

## Gestion des utilisateurs

### Accès à Keycloak
- URL : http://localhost:8080
- Identifiants par défaut :
  - Utilisateur : admin
  - Mot de passe : admin

### Ajouter un utilisateur dans Keycloak

1. Se connecter à l'interface d'administration Keycloak
2. Sélectionner le realm "intranet"
3. Aller dans "Users" > "Add user"
4. Remplir les informations :
   - Username
   - Email
   - First Name
   - Last Name
5. Dans l'onglet "Credentials" :
   - Définir le mot de passe
   - Désactiver "Temporary" si nécessaire

### Gérer les rôles
1. Dans Keycloak, aller dans "Roles"
2. Créer/modifier les rôles selon les besoins
3. Assigner les rôles aux utilisateurs

## Gestion de Nextcloud

### Accès à l'interface
- URL : http://localhost:8081/nextcloud
- Identifiants par défaut :
  - Utilisateur : admin
  - Mot de passe : admin

### Configuration Keycloak
1. Aller dans Administration > Sécurité
2. Activer l'authentification Keycloak
3. Configurer avec les paramètres :
   - URL : http://keycloak:8080
   - Realm : intranet
   - Client ID : intranet-client

## Monitoring

### Accès à Grafana
- URL : http://localhost:8081/grafana
- Identifiants par défaut :
  - Utilisateur : admin
  - Mot de passe : admin

### Accès à Prometheus
- URL : http://localhost:8081/prometheus

## Maintenance

### Sauvegardes

#### Base de données
```bash
docker exec mysql mysqldump -u root -p nextcloud > backup_$(date +%Y%m%d).sql
```

#### Fichiers Nextcloud
```bash
docker cp nextcloud:/var/www/html ./backup_nextcloud_$(date +%Y%m%d)
```

### Logs

#### Voir les logs d'un service
```bash
docker-compose logs [service_name]
```

#### Suivre les logs en temps réel
```bash
docker-compose logs -f [service_name]
```

## Dépannage

### Redémarrer un service
```bash
docker-compose restart [service_name]
```

### Vérifier l'état des services
```bash
docker-compose ps
```

### Vérifier les logs d'erreur
```bash
docker-compose logs [service_name] | grep -i error
```

## Sécurité

### Rotation des logs
Les logs sont automatiquement rotés par Docker. Pour forcer une rotation :
```bash
docker-compose exec nginx nginx -s reopen
```

### Mise à jour des services
```bash
docker-compose pull
docker-compose up -d
``` 