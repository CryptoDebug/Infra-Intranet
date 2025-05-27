Write-Host "Déploiement de l'intranet d'entreprise..."

# Vérification de Docker et Docker Compose
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
}
if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Error "Docker Compose n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
}

Write-Host "Création des certificats SSL..."
$sslDir = "config/nginx/ssl"
if (-not (Test-Path $sslDir)) {
    New-Item -ItemType Directory -Path $sslDir -Force
}

# Génération des certificats SSL (auto-signés)
$certPath = "$sslDir/nextcloud.crt"
$keyPath = "$sslDir/nextcloud.key"
if (-not (Test-Path $certPath) -or -not (Test-Path $keyPath)) {
    $gitBashPath = "C:\Program Files\Git\bin\bash.exe"
    if (Test-Path $gitBashPath) {
        $command = "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $keyPath -out $certPath -subj '/C=FR/ST=IDF/L=Paris/O=Mon Entreprise/CN=nextcloud.monentreprise.local'"
        & $gitBashPath -c $command
    } else {
        Write-Error "Git Bash not found. Please install Git."
        exit 1
    }
}

Write-Host "Démarrage des services..."
docker-compose up -d

Write-Host "Vérification des services..."
$services = @("mysql", "postgres", "keycloak", "nextcloud", "intranet", "prometheus", "grafana")
foreach ($service in $services) {
    $containerName = "infra-intranet-${service}-1"
    $status = docker ps --filter "name=$containerName" --format "{{.Status}}"
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