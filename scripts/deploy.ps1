# Script de déploiement de l'intranet
Write-Host "Déploiement de l'intranet d'entreprise..."

# Vérification de Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
}

# Vérification de Docker Compose
if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Error "Docker Compose n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
}

# Création des certificats SSL auto-signés
Write-Host "Création des certificats SSL..."
$sslDir = "config/nginx/ssl"
if (-not (Test-Path $sslDir)) {
    New-Item -ItemType Directory -Path $sslDir -Force
}

# Génération des certificats SSL
$certPath = "$sslDir/nextcloud.crt"
$keyPath = "$sslDir/nextcloud.key"
if (-not (Test-Path $certPath) -or -not (Test-Path $keyPath)) {
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 `
        -keyout $keyPath -out $certPath `
        -subj "/C=FR/ST=IDF/L=Paris/O=Mon Entreprise/CN=nextcloud.monentreprise.local"
}

# Démarrage des services
Write-Host "Démarrage des services..."
docker-compose up -d

# Vérification des services
Write-Host "Vérification des services..."
$services = @("ldap", "nextcloud", "db", "nginx", "prometheus", "grafana")
foreach ($service in $services) {
    $status = docker-compose ps $service
    if ($status -match "Up") {
        Write-Host "$service est démarré avec succès" -ForegroundColor Green
    } else {
        Write-Host "$service n'a pas démarré correctement" -ForegroundColor Red
    }
}

Write-Host "`nDéploiement terminé !"
Write-Host "Services disponibles :"
Write-Host "- Nextcloud : https://nextcloud.monentreprise.local"
Write-Host "- Grafana : http://localhost:3000"
Write-Host "- Prometheus : http://localhost:9090" 