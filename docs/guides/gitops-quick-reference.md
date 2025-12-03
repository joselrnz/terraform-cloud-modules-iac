# GitOps Deployment - Quick Reference

**One-page quick reference for GitOps deployments**

---

## 🚀 Quick Deploy

### **Deploy app.joselrnz.com**

```bash
cd apps/app
# ... make changes ...
git add .
git commit -m "feat: your change"
git push origin main
# Done! Automatic deployment in ~2 minutes
```

### **Deploy webkali.joselrnz.com**

```bash
cd apps/webkali
# ... make changes ...
git add .
git commit -m "feat: your change"
git push origin main
# Done! Automatic deployment in ~2 minutes
```

---

## 📊 Check Status

### **ArgoCD UI**
https://argo.joselrnz.com

### **Command Line**

```bash
# Set kubeconfig
$env:KUBECONFIG = "$env:USERPROFILE\.kube\k3s.yaml"

# Check ArgoCD applications
kubectl get applications -n argocd

# Check pods
kubectl get pods -n cloud

# Check ingresses
kubectl get ingress -n cloud

# Watch deployments
kubectl get pods -n cloud -w
```

---

## 🔄 Deployment Workflow

```
1. Edit code → apps/app/src/...
2. Commit → git commit -m "feat: ..."
3. Push → git push origin main
4. GitHub Actions → Builds & pushes image
5. Updates manifest → k8s/base/apps/app/deployment.yaml
6. ArgoCD detects → Syncs automatically
7. Live! → https://app.joselrnz.com
```

---

## 🆘 Troubleshooting

### **Deployment not happening?**

```bash
# Check GitHub Actions
# Go to: https://github.com/joselrnz/terraform-cloud-modules-iac/actions

# Check ArgoCD sync status
kubectl get application app -n argocd -o yaml

# Manual sync
kubectl patch application app -n argocd --type merge -p '{"operation":{"initiatedBy":{"username":"admin"},"sync":{"revision":"HEAD"}}}'
```

### **Pod not starting?**

```bash
# Check pod status
kubectl get pods -n cloud

# Describe pod
kubectl describe pod <pod-name> -n cloud

# Check logs
kubectl logs <pod-name> -n cloud

# Check events
kubectl get events -n cloud --sort-by='.lastTimestamp'
```

### **Image pull error?**

```bash
# Check if image exists
# Go to: https://github.com/joselrnz?tab=packages

# Check secret
kubectl get secret ghcr-pull-secret -n cloud

# Recreate secret if needed
kubectl delete secret ghcr-pull-secret -n cloud
kubectl create secret docker-registry ghcr-pull-secret \
  --docker-server=ghcr.io \
  --docker-username=joselrnz \
  --docker-password=<YOUR_GITHUB_TOKEN> \
  --namespace=cloud
```

---

## 🔙 Rollback

### **Method 1: Revert Git Commit**

```bash
# Revert last commit
git revert HEAD
git push origin main

# ArgoCD will automatically rollback
```

### **Method 2: Rollback to Specific Version**

```bash
# Find commit hash
git log --oneline

# Revert to specific commit
git revert <commit-hash>
git push origin main
```

### **Method 3: Emergency Rollback**

```bash
# Rollback deployment (bypasses GitOps!)
kubectl rollout undo deployment/app-nginx -n cloud

# Remember to update Git to match!
```

---

## 📝 Common Tasks

### **View Logs**

```bash
# Real-time logs
kubectl logs -n cloud -l app=app-nginx -f

# Last 100 lines
kubectl logs -n cloud -l app=app-nginx --tail=100

# Logs from previous pod
kubectl logs -n cloud <pod-name> --previous
```

### **Restart Pod**

```bash
# Restart deployment
kubectl rollout restart deployment/app-nginx -n cloud

# Delete specific pod (will be recreated)
kubectl delete pod <pod-name> -n cloud
```

### **Scale Deployment**

```bash
# Scale to 3 replicas
kubectl scale deployment/app-nginx -n cloud --replicas=3

# Scale to 1 replica
kubectl scale deployment/app-nginx -n cloud --replicas=1
```

### **Update Environment Variable**

```bash
# Edit deployment
kubectl edit deployment app-nginx -n cloud

# Or update in Git (recommended)
# Edit: k8s/base/apps/app/deployment.yaml
# Commit and push
```

---

## 🆕 Create New App

### **Quick Steps**

```bash
# 1. Create app directory
mkdir -p apps/myapp
cd apps/myapp
# ... create Dockerfile, package.json, etc ...

# 2. Create k8s manifests
mkdir -p k8s/base/apps/myapp
# ... create deployment.yaml, service.yaml, ingress.yaml, kustomization.yaml ...

# 3. Create ArgoCD application
# Copy k8s/argocd/applications/app.yaml
# Modify for your app

# 4. Create GitHub Actions workflow
# Copy .github/workflows/deploy-app.yml
# Modify for your app

# 5. Add Cloudflare DNS
# Type: A, Name: myapp, Content: 137.184.59.17, Proxy: Yes

# 6. Commit and push
git add .
git commit -m "feat: add myapp"
git push origin main

# 7. Apply ArgoCD application
kubectl apply -f k8s/argocd/applications/myapp.yaml
```

---

## 🔗 Links

- **ArgoCD UI:** https://argo.joselrnz.com
- **GitHub Actions:** https://github.com/joselrnz/terraform-cloud-modules-iac/actions
- **GitHub Packages:** https://github.com/joselrnz?tab=packages
- **Full Guide:** [docs/guides/gitops-deployment-guide.md](gitops-deployment-guide.md)

---

## 📋 Checklist for New Deployment

- [ ] App code in `apps/<name>/`
- [ ] Dockerfile created
- [ ] K8s manifests in `k8s/base/apps/<name>/`
- [ ] ArgoCD application in `k8s/argocd/applications/<name>.yaml`
- [ ] GitHub Actions workflow in `.github/workflows/deploy-<name>.yml`
- [ ] Cloudflare DNS record added
- [ ] Committed and pushed to GitHub
- [ ] ArgoCD application applied
- [ ] Verified deployment in ArgoCD UI
- [ ] Tested access at `https://<name>.joselrnz.com`

---

**Last Updated:** 2025-11-23  
**Apps:** app, webkali

