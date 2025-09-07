# 🎬 Netflix Clone – DevSecOps Project

A full-stack **DevSecOps implementation** showcasing how to build, secure, deploy, and monitor a **Netflix clone** using cutting-edge tools like **Terraform, Ansible, Jenkins, ArgoCD, Vault, Tailscale, Prometheus, Grafana, Trivy, and SonarQube**.

---

## 🧠 What This Project Covers

- Local VMs (RHEL 9.6) on **VMware**  
  - 1x DevOps VM (Terraform + Ansible + Vault)  
  - 1x Kubernetes Master node  
  - 2x Kubernetes Worker nodes  

- Jenkins Master/Slave deployment on **Azure** using **Terraform** (secured by Vault)  
- Secure networking using **Tailscale VPN** between local and Azure  
- Kubernetes cluster configuration & monitoring setup with **Ansible**  
- GitOps deployment with **ArgoCD**  
- Monitoring with **Prometheus + Grafana + Node Exporter**  
- CI/CD pipelines with **Jenkins** (GitHub, SonarQube, Docker, Trivy, GitLab Registry)  
- Application deployment via **NGINX Ingress + MetalLB**  
- Final domain: 🌍 **www.netflix-mohamedaziz_benabbes.com**

---

📊 Project Architecture Diagram

📸 *[Place ton diagramme ici]*

---

📁 Project Tree Overview
```
Netflix-DevSecOps
├── ansible
│   ├── inventory.yml
│   ├── playbook.yml
│   └── roles
│       ├── cluster_k8
│       ├── monitoring
│       ├── argoCd
│       └── jenkins
├── terraform
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
├── Jenkinsfile
├── argocd
│   └── dep.yml
└── README.md
```

---

## 🛠️ Step-by-Step Implementation

### 🔹 1. Local Kubernetes Cluster (VMware)

Created 4 VMs on **VMware (RHEL 9.6)**:  
- **DevOps VM** → Terraform, Ansible, Vault  
- **Master Node** → Kubernetes master  
- **Worker1 & Worker2** → Kubernetes workers  

<img width="204" height="201" alt="vmVmware" src="https://github.com/user-attachments/assets/ccdc6d9d-9f03-4297-922c-c780b1c92471" />

---

### 🔹 2. Jenkins Infrastructure (Azure) with Terraform + Vault

Provisioned **Jenkins Master and Slave VMs** on Azure with Terraform, secured via Vault.

📂 Terraform Files:
- `main.tf` → Azure resources (RG, VNet, Subnet, NSG, VMs)  
- `variables.tf` → Configurable variables  
- `outputs.tf` → Outputs (IPs, RG)  
- `provider.tf` → Azure provider + Vault integration  

🔐 **Vault** stores only:  
- **SSH key** (private)  
- **Usernames & passwords** of Azure VMs  

👉 The **SSH public key** was generated on the **DevOps VM (local)** to ensure that the DevOps machine can securely connect to Azure VMs.  

📸 *Capture : Terraform plan & apply*  
📸 *Capture : Vault secrets*

---

### 🔹 3. Secure Connectivity with Tailscale

Configured **Tailscale VPN** across all local and Azure VMs:  
- Ensures encrypted communication 🔒  
- Simplifies Ansible inventory (IP Tailscale)  
- Enables secure monitoring between environments  

📸 *Capture : Tailscale dashboard*

---

### 🔹 4. Configuration Management with Ansible

Before creating roles, I generated an SSH key and copied it to all machines for secure access:  
```bash
ssh-keygen
ssh-copy-id <ip_machine>
```

📂 Ansible Roles:
- `cluster_k8` → Setup K8s cluster (1 master, 2 workers)  
- `monitoring` → Deploy Prometheus + Grafana + Node Exporter  
- `argoCd` → Deploy ArgoCD into Kubernetes  
- `jenkins` → Configure Jenkins on Azure VMs  

Execution:
```bash
ansible-playbook -i inventory.yml playbook.yml
```

📸 *Capture : Ansible run output*

---

### 🔹 5. Monitoring with Prometheus & Grafana

- **Prometheus** → metrics collection  
- **Node Exporter** → system metrics from Azure VMs  
- **Grafana** → visualization dashboards  

📸 *Capture : Grafana dashboards*  
📸 *Capture : Prometheus targets*

---

### 🔹 6. CI/CD with Jenkins Pipelines

The pipeline was **executed on the Jenkins Slave** in Azure.  

📸 *Capture : pipeline running on Slave (2 screenshots)*  
📸 *Capture : Jenkins job start (pipeline launched)*  

Pipeline stages (`Jenkinsfile`):  

1. **Clone repo from GitHub** 📂  

2. **Scan code with SonarQube** 🧪  
   📸 *2 captures : SonarQube analysis results*  

3. **Build Docker image (with TMDB API key via Vault)** 🐳  
   *(no screenshots available for this step)*  

4. **Scan Docker image with Trivy** 🔒  
   📸 *1 capture : Trivy scan results*  

5. **Push Docker image to GitLab Registry** 📦  
   📸 *1 capture : Push success*  

6. **Update `dep.yml` in repo (for ArgoCD auto-sync)** ✏️  
   📸 *1 capture : dep.yml commit update*  

7. **Pipeline Success** ✅  
   📸 *2 captures : success messages*  
   📸 *1 capture : pipeline all green*  

---

### 🔹 7. GitOps Deployment with ArgoCD

- **ArgoCD** was already installed via Ansible.  
- Configured to **auto-sync** with GitHub repo.  
- Every commit on `dep.yml` → automatic redeployment.  
- Application exposed externally via:  
  - **MetalLB** → External IP  
  - **NGINX Ingress** → Domain-based access  

📸 *Capture : ArgoCD auto-sync dashboard*  
📸 *Capture : MetalLB external IP*  
📸 *Capture : Ingress resources*

---

## 🎉 Final Result

Netflix Clone accessible at:  
🌍 **www.netflix-mohamedaziz_benabbes.com**

📸 *Capture finale du site Netflix clone*

---

## 🙏 Remerciements

Merci à toutes les personnes qui ont pris le temps de visiter mon GitHub et de lire ce projet 🚀.  
Je suis disponible pour toutes vos **questions** ou **suggestions** !  

👤 **Mohamed Aziz Ben Abbes**  
📧 [benabbes.mohamedaziz30@gmail.com](mailto:benabbes.mohamedaziz30@gmail.com)  
