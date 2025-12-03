# Cloudflare Origin Certificates

This directory contains the **Cloudflare Origin Certificates** used for **Full (Strict) SSL/TLS mode**.

---

## 📁 Files in This Directory

- **`joselrnz.com.pem`** - Cloudflare Origin Certificate (public certificate)
- **`joselrnz.com.key`** - Private key for the certificate

---

## 🔐 Certificate Details

| Property | Value |
|----------|-------|
| **Subject** | Cloudflare |
| **Issuer** | Cloudflare Managed CA |
| **Valid From** | Nov 18, 2025 |
| **Valid Until** | Nov 16, 2035 (10 years) |
| **Type** | Origin Certificate |
| **Purpose** | Cloudflare Full (Strict) SSL/TLS |

---

## 🎯 Purpose

These certificates enable **Cloudflare Full (Strict) SSL/TLS mode**:

```
Browser (HTTPS)
    ↓
Cloudflare (Validates origin cert)
    ↓ [Full (Strict) SSL/TLS]
Traefik (Uses cloudflare-origin-cert)
    ↓
Your Apps (k8s pods)
```

---

## 📦 Where They're Used

### **1. Kubernetes Secret**

The certificates are stored in a Kubernetes secret:

```bash
# View secret
kubectl get secret cloudflare-origin-cert -n kube-system

# Describe secret
kubectl describe secret cloudflare-origin-cert -n kube-system
```

**Secret Details:**
- **Name:** `cloudflare-origin-cert`
- **Namespace:** `kube-system`
- **Type:** `kubernetes.io/tls`
- **Contains:** `tls.crt` (pem file) + `tls.key` (key file)

### **2. Traefik TLSStore**

Traefik uses this as the default certificate for all HTTPS traffic:

**File:** `k8s/base/security/tls-store.yaml`

```yaml
apiVersion: traefik.io/v1alpha1
kind: TLSStore
metadata:
  name: default
  namespace: kube-system
spec:
  defaultCertificate:
    secretName: cloudflare-origin-cert
```

### **3. Ingress Resources**

Some ingresses explicitly reference the certificate:

- `k8s/base/apps/app/ingress.yaml` - app.joselrnz.com
- `k8s/base/apps/argo-cd/ingress.yaml` - argo.joselrnz.com

All other ingresses use it implicitly via the TLSStore default.

---

## 🔄 How to Recreate the Kubernetes Secret

If you ever need to recreate the secret from these files:

```bash
# Delete old secret (if exists)
kubectl delete secret cloudflare-origin-cert -n kube-system

# Create new secret from files
kubectl create secret tls cloudflare-origin-cert \
  --cert=k8s/secrets/.cert/joselrnz.com.pem \
  --key=k8s/secrets/.cert/joselrnz.com.key \
  --namespace=kube-system

# Verify
kubectl get secret cloudflare-origin-cert -n kube-system
```

---

## 🔄 How to Regenerate Certificates

If the certificates expire or you need new ones:

### **Option 1: Cloudflare Dashboard**

1. Login to Cloudflare Dashboard
2. Go to **SSL/TLS** → **Origin Server**
3. Click **Create Certificate**
4. Select:
   - **Private key type:** RSA (2048)
   - **Hostnames:** `*.joselrnz.com`, `joselrnz.com`
   - **Certificate Validity:** 15 years (max)
5. Click **Create**
6. Copy the **Origin Certificate** → Save as `joselrnz.com.pem`
7. Copy the **Private Key** → Save as `joselrnz.com.key`
8. Recreate the Kubernetes secret (see above)

### **Option 2: Cloudflare API**

```bash
# Use Cloudflare API to generate new certificate
# See: https://developers.cloudflare.com/api/operations/origin-ca-create-certificate
```

---

## ⚠️ Security Notes

### **Important:**

1. **Never commit these files to git!**
   - The `.cert` directory is in `.gitignore`
   - Private keys should never be in version control

2. **Keep these files secure:**
   - Only store in encrypted locations
   - Limit access to authorized personnel only
   - Rotate certificates before expiration

3. **Backup strategy:**
   - Store encrypted backups in secure location
   - Document certificate expiration dates
   - Set reminders for certificate renewal

### **Current Protection:**

- ✅ Stored in `.cert` directory (hidden directory)
- ✅ Added to `.gitignore` (won't be committed)
- ✅ Only used for Kubernetes secret creation
- ✅ Not referenced directly by any code

---

## 📋 Certificate Lifecycle

### **Current Status:**
- ✅ Certificate valid until **Nov 16, 2035**
- ✅ Stored in Kubernetes secret
- ✅ Used by Traefik for all HTTPS traffic
- ✅ Backup stored in `k8s/secrets/.cert/`

### **Renewal Timeline:**
- **2034:** Start planning certificate renewal
- **2035 (Nov):** Certificate expires - must renew before this date

---

## 🔍 Verification

### **Check Certificate in Kubernetes:**

```bash
# Check secret exists
kubectl get secret cloudflare-origin-cert -n kube-system

# View certificate details
kubectl get secret cloudflare-origin-cert -n kube-system -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -text
```

### **Check Certificate Files:**

```bash
# View certificate details
openssl x509 -in k8s/secrets/.cert/joselrnz.com.pem -noout -text

# Verify private key matches certificate
openssl x509 -noout -modulus -in k8s/secrets/.cert/joselrnz.com.pem | openssl md5
openssl rsa -noout -modulus -in k8s/secrets/.cert/joselrnz.com.key | openssl md5
# (The MD5 hashes should match)
```

---

## 📚 Related Documentation

- [Cloudflare Full (Strict) SSL/TLS](https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes/full-strict/)
- [Cloudflare Origin CA](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/)
- [Traefik TLS Configuration](https://doc.traefik.io/traefik/https/tls/)

---

**Last Updated:** 2025-11-23  
**Certificate Expiration:** 2035-11-16  
**Managed By:** joselrnz

