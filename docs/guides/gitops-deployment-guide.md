# GitOps Deployment Guide

Complete guide for deploying applications using GitOps workflow with ArgoCD.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Initial Setup](#initial-setup)
5. [Deploying Updates](#deploying-updates)
6. [Creating New Apps](#creating-new-apps)
7. [Troubleshooting](#troubleshooting)

---

## Overview

### **What is GitOps?**

GitOps is a deployment methodology where:
- **Git is the single source of truth** for infrastructure and applications
- **Changes are made via Git commits** (not kubectl apply)
- **ArgoCD automatically syncs** cluster state with Git state
- **Rollbacks are simple** (just revert the Git commit)

### **Your GitOps Workflow**

```
┌─────────────────────────────────────────────────────────────────┐
│                    Complete GitOps Workflow                     │
└─────────────────────────────────────────────────────────────────┘

Step 1: Developer makes changes to app code
        └─> apps/app/src/...

Step 2: Developer commits and pushes to GitHub
        └─> git push origin main

Step 3: GitHub Actions triggers automatically
        ├─> Builds Docker image
        ├─> Pushes to ghcr.io/joselrnz/app:main-abc1234
        └─> Updates k8s/base/apps/app/deployment.yaml with new image tag

Step 4: ArgoCD detects change in Git
        └─> Compares cluster state vs Git state

Step 5: ArgoCD syncs automatically
        ├─> Pulls new image
        ├─> Updates deployment
        └─> Waits for rollout to complete

Step 6: App is live!
        └─> https://app.joselrnz.com
```

---

## Architecture

### **Components**

```
┌──────────────────────────────────────────────────────────────┐
│                         GitHub                               │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐ │
│  │  App Code      │  │  K8s Manifests │  │  GitHub Actions│ │
│  │  apps/app/     │  │  k8s/base/     │  │  .github/      │ │
│  └────────────────┘  └────────────────┘  └────────────────┘ │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                   GitHub Container Registry                  │
│              ghcr.io/joselrnz/app:main-abc1234              │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                        │
│  ┌────────────────────────────────────────────────────────┐  │
│  │                      ArgoCD                            │  │
│  │  - Watches Git repository                             │  │
│  │  - Detects changes in k8s manifests                   │  │
│  │  - Syncs cluster state with Git state                 │  │
│  └────────────────────────────────────────────────────────┘  │
│                              │                               │
│                              ▼                               │
│  ┌────────────────────────────────────────────────────────┐  │
│  │                  Your Applications                     │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐            │  │
│  │  │   app    │  │ webkali  │  │  cloud   │            │  │
│  │  └──────────┘  └──────────┘  └──────────┘            │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

### **1. Repository Structure**

Your repository should have this structure:

```
terraform-cloud-modules-iac/
├── apps/                          # Application source code
│   ├── app/                       # app.joselrnz.com
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── src/
│   └── webkali/                   # webkali.joselrnz.com
│       ├── Dockerfile
│       ├── package.json
│       └── src/
├── k8s/                           # Kubernetes manifests
│   ├── argocd/
│   │   └── applications/
│   │       ├── app.yaml           # ArgoCD Application for app
│   │       └── webkali.yaml       # ArgoCD Application for webkali
│   └── base/
│       └── apps/
│           ├── app/
│           │   ├── deployment.yaml
│           │   ├── service.yaml
│           │   ├── ingress.yaml
│           │   └── kustomization.yaml
│           └── webkali/
│               ├── deployment.yaml
│               ├── service.yaml
│               ├── ingress.yaml
│               └── kustomization.yaml
└── .github/
    └── workflows/
        ├── deploy-app.yml         # GitHub Actions for app
        └── deploy-webkali.yml     # GitHub Actions for webkali
```

### **2. GitHub Secrets**

No additional secrets needed! GitHub Actions uses `GITHUB_TOKEN` automatically.

### **3. Cloudflare DNS**

Add DNS records for new apps:

| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | webkali | 137.184.59.17 | ✅ Proxied |

---

## Initial Setup

### **Step 1: Apply ArgoCD Applications**

```bash
# Set kubeconfig
$env:KUBECONFIG = "$env:USERPROFILE\.kube\k3s.yaml"

# Apply ArgoCD Application for app
kubectl apply -f k8s/argocd/applications/app.yaml

# Apply ArgoCD Application for webkali
kubectl apply -f k8s/argocd/applications/webkali.yaml

# Check status
kubectl get applications -n argocd
```

**Expected output:**
```
NAME      SYNC STATUS   HEALTH STATUS
app       Synced        Healthy
webkali   Synced        Healthy
```

### **Step 2: Access ArgoCD UI**

1. Visit: https://argo.joselrnz.com
2. Login with your credentials
3. You should see two applications: `app` and `webkali`

### **Step 3: Verify Deployment**

```bash
# Check app pods
kubectl get pods -n cloud

# Check ingresses
kubectl get ingress -n cloud

# Test access
curl -I https://app.joselrnz.com
curl -I https://webkali.joselrnz.com
```

---

## Deploying Updates

### **Method 1: Automatic Deployment (Recommended)**

This is the GitOps way - just push code to GitHub!

#### **For app.joselrnz.com:**

```bash
# 1. Make changes to your app
cd apps/app
# ... edit files ...

# 2. Commit and push
git add .
git commit -m "feat: add new feature"
git push origin main

# 3. GitHub Actions will automatically:
#    - Build Docker image
#    - Push to GHCR
#    - Update k8s manifest
#    - ArgoCD will detect and deploy

# 4. Monitor deployment
# Visit: https://argo.joselrnz.com
# Or check logs:
kubectl logs -n cloud -l app=app-nginx --tail=50
```

#### **For webkali.joselrnz.com:**

```bash
# 1. Make changes to your app
cd apps/webkali
# ... edit files ...

# 2. Commit and push
git add .
git commit -m "feat: add new feature"
git push origin main

# 3. Automatic deployment happens
# 4. Monitor at https://argo.joselrnz.com
```

### **Method 2: Manual Deployment**

If you need to deploy manually:

```bash
# 1. Build and push image manually
cd apps/app
docker build -t ghcr.io/joselrnz/app:v1.0.0 .
docker push ghcr.io/joselrnz/app:v1.0.0

# 2. Update manifest
sed -i 's|image: ghcr.io/joselrnz/app:.*|image: ghcr.io/joselrnz/app:v1.0.0|g' k8s/base/apps/app/deployment.yaml

# 3. Commit and push
git add k8s/base/apps/app/deployment.yaml
git commit -m "chore: update app to v1.0.0"
git push origin main

# 4. ArgoCD will automatically sync
```

### **Method 3: Emergency Deployment (Not Recommended)**

Only use this in emergencies:

```bash
# This bypasses GitOps - use only for emergencies!
kubectl set image deployment/app-nginx app=ghcr.io/joselrnz/app:emergency-fix -n cloud

# Remember to update Git afterwards to match cluster state!
```

---

## Creating New Apps

### **Example: Creating arduino.joselrnz.com**

#### **Step 1: Create App Directory**

```bash
mkdir -p apps/arduino
cd apps/arduino

# Create Dockerfile
cat > Dockerfile << 'EOF'
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
EOF

# Create your app files
# ... create package.json, src/, etc ...
```

#### **Step 2: Create Kubernetes Manifests**

```bash
mkdir -p k8s/base/apps/arduino

# Create deployment.yaml
cat > k8s/base/apps/arduino/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: arduino
  namespace: cloud
spec:
  replicas: 1
  selector:
    matchLabels:
      app: arduino
  template:
    metadata:
      labels:
        app: arduino
    spec:
      imagePullSecrets:
      - name: ghcr-pull-secret
      containers:
      - name: arduino
        image: ghcr.io/joselrnz/arduino:latest
        ports:
        - containerPort: 3000
        resources:
          requests:
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "512Mi"
            cpu: "500m"
EOF

# Create service.yaml, ingress.yaml, kustomization.yaml
# (Similar to app and webkali)
```

#### **Step 3: Create ArgoCD Application**

```bash
cat > k8s/argocd/applications/arduino.yaml << 'EOF'
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: arduino
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/joselrnz/terraform-cloud-modules-iac.git
    targetRevision: main
    path: k8s/base/apps/arduino
  destination:
    server: https://kubernetes.default.svc
    namespace: cloud
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF
```

#### **Step 4: Create GitHub Actions Workflow**

```bash
# Copy and modify deploy-app.yml
cp .github/workflows/deploy-app.yml .github/workflows/deploy-arduino.yml

# Edit to change:
# - paths: 'apps/arduino/**'
# - IMAGE_NAME: arduino
# - deployment path: k8s/base/apps/arduino/deployment.yaml
```

#### **Step 5: Add Cloudflare DNS**

Add A record in Cloudflare:
- Type: A
- Name: arduino
- Content: 137.184.59.17
- Proxy: ✅ Enabled

#### **Step 6: Deploy**

```bash
# Commit everything
git add .
git commit -m "feat: add arduino app"
git push origin main

# Apply ArgoCD Application
kubectl apply -f k8s/argocd/applications/arduino.yaml

# Monitor deployment
kubectl get applications -n argocd
```

---

## Troubleshooting

### **ArgoCD Application Not Syncing**

**Check sync status:**
```bash
kubectl get application app -n argocd -o yaml
```

**Manual sync:**
```bash
# Via CLI
argocd app sync app

# Or via UI
# Visit https://argo.joselrnz.com → Click app → Click SYNC
```

### **GitHub Actions Failing**

**Check workflow logs:**
1. Go to GitHub repository
2. Click "Actions" tab
3. Click on failed workflow
4. Check logs for errors

**Common issues:**
- Docker build fails → Check Dockerfile
- Image push fails → Check GHCR permissions
- Git push fails → Check GitHub token permissions

### **Pod Not Starting**

**Check pod status:**
```bash
kubectl get pods -n cloud
kubectl describe pod <pod-name> -n cloud
kubectl logs <pod-name> -n cloud
```

**Common issues:**
- ImagePullBackOff → Check image exists in GHCR
- CrashLoopBackOff → Check application logs
- Pending → Check resource limits

---

## Best Practices

### **1. Use Semantic Versioning**

```bash
# Tag releases
git tag v1.0.0
git push origin v1.0.0

# Update image tag
image: ghcr.io/joselrnz/app:v1.0.0
```

### **2. Use Separate Branches**

```
main → Production (app.joselrnz.com)
develop → Development (appdev.joselrnz.com)
feature/* → Feature branches
```

### **3. Review Before Merge**

```bash
# Create pull request
git checkout -b feature/new-feature
# ... make changes ...
git push origin feature/new-feature

# Create PR on GitHub
# Review → Approve → Merge
# ArgoCD will deploy automatically
```

### **4. Monitor Deployments**

```bash
# Watch ArgoCD
kubectl get applications -n argocd -w

# Watch pods
kubectl get pods -n cloud -w

# Check logs
kubectl logs -n cloud -l app=app-nginx -f
```

---

## Quick Reference

### **Deploy app.joselrnz.com**

```bash
cd apps/app
# ... make changes ...
git add .
git commit -m "feat: update"
git push origin main
# Done! GitHub Actions + ArgoCD handle the rest
```

### **Deploy webkali.joselrnz.com**

```bash
cd apps/webkali
# ... make changes ...
git add .
git commit -m "feat: update"
git push origin main
# Done!
```

### **Check Deployment Status**

```bash
# ArgoCD applications
kubectl get applications -n argocd

# Pods
kubectl get pods -n cloud

# Ingresses
kubectl get ingress -n cloud
```

### **Rollback**

```bash
# Revert Git commit
git revert HEAD
git push origin main

# ArgoCD will automatically rollback
```

---

**Last Updated:** 2025-11-23  
**Maintained By:** joselrnz

