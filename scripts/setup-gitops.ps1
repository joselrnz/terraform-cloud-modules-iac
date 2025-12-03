# GitOps Setup Script
# Sets up ArgoCD applications for GitOps workflow

param(
    [switch]$DryRun = $false
)

# Set kubeconfig
$env:KUBECONFIG = "$env:USERPROFILE\.kube\k3s.yaml"

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       GitOps Setup Script v1.0.0       ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "⚠️  DRY RUN MODE - No changes will be made" -ForegroundColor Yellow
    Write-Host ""
}

# Check if ArgoCD is installed
Write-Host "1. Checking ArgoCD installation..." -ForegroundColor Yellow
$argocdPods = kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}' 2>&1
if ($LASTEXITCODE -ne 0 -or -not $argocdPods) {
    Write-Host "❌ ArgoCD is not installed!" -ForegroundColor Red
    Write-Host "Please install ArgoCD first." -ForegroundColor Red
    exit 1
}
Write-Host "✅ ArgoCD is installed" -ForegroundColor Green

# Check if applications directory exists
Write-Host ""
Write-Host "2. Checking ArgoCD applications directory..." -ForegroundColor Yellow
if (-not (Test-Path "k8s/argocd/applications")) {
    Write-Host "❌ Directory k8s/argocd/applications not found!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Applications directory exists" -ForegroundColor Green

# List available applications
Write-Host ""
Write-Host "3. Available ArgoCD applications:" -ForegroundColor Yellow
$apps = Get-ChildItem "k8s/argocd/applications" -Filter "*.yaml"
foreach ($app in $apps) {
    Write-Host "   - $($app.BaseName)" -ForegroundColor Cyan
}

# Apply applications
Write-Host ""
Write-Host "4. Applying ArgoCD applications..." -ForegroundColor Yellow

foreach ($app in $apps) {
    $appName = $app.BaseName
    Write-Host ""
    Write-Host "   Applying: $appName" -ForegroundColor Cyan
    
    if ($DryRun) {
        Write-Host "   [DRY RUN] Would apply: $($app.FullName)" -ForegroundColor Gray
    } else {
        kubectl apply -f $app.FullName 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ $appName applied successfully" -ForegroundColor Green
        } else {
            Write-Host "   ❌ Failed to apply $appName" -ForegroundColor Red
        }
    }
}

# Wait for applications to be created
if (-not $DryRun) {
    Write-Host ""
    Write-Host "5. Waiting for applications to be created..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
}

# Check application status
Write-Host ""
Write-Host "6. Checking application status..." -ForegroundColor Yellow
if ($DryRun) {
    Write-Host "   [DRY RUN] Would check application status" -ForegroundColor Gray
} else {
    kubectl get applications -n argocd 2>&1
}

# Summary
Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║       GitOps Setup Complete!           ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

if (-not $DryRun) {
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Access ArgoCD UI: https://argo.joselrnz.com" -ForegroundColor White
    Write-Host "2. Check application status:" -ForegroundColor White
    Write-Host "   kubectl get applications -n argocd" -ForegroundColor Gray
    Write-Host "3. Monitor deployments:" -ForegroundColor White
    Write-Host "   kubectl get pods -n cloud -w" -ForegroundColor Gray
    Write-Host "4. Push code changes to trigger deployments!" -ForegroundColor White
    Write-Host ""
    Write-Host "Documentation: docs/guides/gitops-deployment-guide.md" -ForegroundColor Cyan
} else {
    Write-Host "This was a dry run. Run without -DryRun to apply changes." -ForegroundColor Yellow
}

Write-Host ""

