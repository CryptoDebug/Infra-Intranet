# Guide d'Exploitation de l'Intranet

## Démarrage rapide

### Prérequis
- Docker et Docker Compose installés
- PowerShell 5.0 ou supérieur
- Accès administrateur

### Installation

1. Cloner le dépôt :
```bash
git clone https://github.com/CryptoDebug/Infra-Intranet
cd Infra-Intranet
```

2. Lancer le script de déploiement :
```powershell
.\scripts\deploy.ps1
```

## Gestion des utilisateurs

### Ajouter un utilisateur LDAP

1. Se connecter au conteneur LDAP :
```bash
docker exec -it ldap bash
```

2. Créer un nouvel utilisateur :
```bash
ldapadd -x -D "cn=admin,dc=monentreprise,dc=local" -W
```

3. Entrer le contenu LDIF suivant :
```ldif
dn: uid=john.doe,ou=users,dc=monentreprise,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: john.doe
sn: Doe
givenName: John
cn: John Doe
displayName: John Doe
uidNumber: 1000
gidNumber: 1000
userPassword: {SSHA}password_hash
homeDirectory: /home/john.doe
loginShell: /bin/bash
```

### Supprimer un utilisateur LDAP

```bash
ldapdelete -x -D "cn=admin,dc=monentreprise,dc=local" -W "uid=john.doe,ou=users,dc=monentreprise,dc=local"
```

## Gestion de Nextcloud

### Accès à l'interface
- URL : https://nextcloud.monentreprise.local
- Identifiants par défaut :
  - Utilisateur : admin
  - Mot de passe : admin_password

### Configuration LDAP
1. Aller dans Administration > Utilisateurs
2. Cliquer sur "Intégration LDAP"
3. Configurer avec les paramètres :
   - Serveur LDAP : ldap
   - Port : 389
   - DN de base : dc=monentreprise,dc=local
   - DN administrateur : cn=admin,dc=monentreprise,dc=local

## Monitoring

### Accès à Grafana
- URL : http://localhost:3000
- Identifiants par défaut :
  - Utilisateur : admin
  - Mot de passe : admin_password

### Accès à Prometheus
- URL : http://localhost:9090

## Maintenance

### Sauvegardes

#### Base de données
```bash
docker exec db mysqldump -u root -p nextcloud > backup_$(date +%Y%m%d).sql
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

### Mise à jour des certificats SSL
1. Générer de nouveaux certificats :
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout config/nginx/ssl/nextcloud.key \
    -out config/nginx/ssl/nextcloud.crt
```

2. Redémarrer Nginx :
```bash
docker-compose restart nginx
```

### Rotation des logs
Les logs sont automatiquement rotés par Docker. Pour forcer une rotation :
```bash
docker-compose exec nginx nginx -s reopen
``` 