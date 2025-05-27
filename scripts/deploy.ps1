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

# Vérification et mise à jour du fichier hosts
Write-Host "Configuration du fichier hosts..."
$hostsPath = "C:\Windows\System32\drivers\etc\hosts"
$hostsEntries = @(
    "127.0.0.1 nextcloud.monentreprise.local",
    "127.0.0.1 grafana.monentreprise.local",
    "127.0.0.1 prometheus.monentreprise.local",
    "127.0.0.1 keycloak.monentreprise.local"
)

$hostsContent = Get-Content $hostsPath
$missingEntries = $hostsEntries | Where-Object { $hostsContent -notcontains $_ }

if ($missingEntries) {
    Write-Host "Ajout des entrées manquantes dans le fichier hosts..."
    $missingEntries | ForEach-Object {
        Add-Content -Path $hostsPath -Value "`n$_"
    }
}

Write-Host "Démarrage des services..."
docker-compose up -d

Write-Host "Vérification des services..."
$services = @("keycloak", "nextcloud", "mysql", "nginx", "prometheus", "grafana")
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
Write-Host "- Interface principale : http://localhost:8081"
Write-Host "- Keycloak : http://localhost:8080"
Write-Host "- Nextcloud : http://localhost:8081/nextcloud"
Write-Host "- Grafana : http://localhost:8081/grafana"
Write-Host "- Prometheus : http://localhost:8081/prometheus"

Write-Host "`nIdentifiants par défaut :"
Write-Host "- Keycloak : admin/admin"
Write-Host "- Nextcloud : admin/admin"
Write-Host "- Grafana : admin/admin" 