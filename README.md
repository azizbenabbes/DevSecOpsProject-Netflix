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
DevSecOpsProject-Netflix
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
├── Dockerfile
├── app
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
I provisioned the following on Azure:

Resource Group: rg-jenkins

Virtual Network: vnet-jenkins (10.10.0.0/16)

Subnets:

Master subnet: 10.10.1.0/24

Slave subnet: 10.10.2.0/24

Network Security Groups for Jenkins VMs

VMs (Ubuntu 22.04 LTS):

Jenkins Master in master subnet (Standard_B2s)

Jenkins Slave in slave subnet (Standard_B1s)

📂 Terraform Files:
- `main.tf` → Azure resources (RG, VNet, Subnet, NSG, VMs)  
- `variables.tf` → Configurable variables  
- `outputs.tf` → Outputs (IPs, RG)  
- `provider.tf` → Azure provider + Vault integration  

🔐 **Vault** stores only:  
- **SSH key** (Public key)  
- **Usernames & passwords** of Azure VMs  

👉 The **SSH public key** was generated on the **DevOps VM (local)** to ensure that the DevOps machine can securely connect to Azure VMs.  

Vault:

<img width="1710" height="725" alt="lance vault" src="https://github.com/user-attachments/assets/9a3ba1c7-4f19-4362-9b5e-f347a998b851" />


 <img width="1209" height="403" alt="lance vault 2" src="https://github.com/user-attachments/assets/e984a5c9-00f8-484d-a69c-d71f320b53d9" />
 
 
<img width="1721" height="325" alt="entre les variable dans vault" src="https://github.com/user-attachments/assets/53163ffd-0e35-45ba-8619-2fbdab0fcf2e" />



<img width="1707" height="855" alt="les secrets jenkins" src="https://github.com/user-attachments/assets/e0b1c398-896d-40e2-8b07-e3981f9aad89" />



Terrafom plan:


<img width="1544" height="803" alt="terraform plan 1" src="https://github.com/user-attachments/assets/a2e8334c-88fa-4937-8021-ef6bb05c0cb8" />



<img width="658" height="230" alt="terraform plan 2" src="https://github.com/user-attachments/assets/525f168c-74ae-4041-9d29-6ec6bc1bea95" />



Terraform Apply :


<img width="1442" height="786" alt="terraform apply 1" src="https://github.com/user-attachments/assets/0ca2cad9-06fb-4aa4-84a3-b004fc4323d9" />



<img width="1720" height="246" alt="terraform apply" src="https://github.com/user-attachments/assets/9f0b3868-c682-49ee-8e34-a0816baef986" />



Azure :


<img width="1883" height="874" alt="rgAzure" src="https://github.com/user-attachments/assets/22b642ff-6502-419f-92a8-45ca82bddc3b" />



<img width="1881" height="807" alt="vmAzure" src="https://github.com/user-attachments/assets/4310b746-bdcb-4065-8bb5-63a05b3831e4" />



---

### 🔹 3. Secure Connectivity with Tailscale

Configured **Tailscale VPN** across all local and Azure VMs:  
- Ensures encrypted communication 🔒  
- Simplifies Ansible inventory (IP Tailscale)  
- Enables secure monitoring between environments  


<img width="1878" height="850" alt="tailscale vms1" src="https://github.com/user-attachments/assets/af250f24-064e-405d-9d97-85845ea8a473" />




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


<img width="1702" height="627" alt="ansible debut" src="https://github.com/user-attachments/assets/b57c7b51-1eef-4ae3-a416-ca9282bbbbab" />




<img width="1445" height="399" alt="ansible fin" src="https://github.com/user-attachments/assets/9f42bf54-7f27-4c0d-a835-2db1e9ab7d41" />




---

### 🔹 5. Monitoring with Prometheus & Grafana

- **Prometheus** → metrics collection  
- **Node Exporter** → system metrics from Azure VMs  
- **Grafana** → visualization dashboards  


<img width="1722" height="843" alt="dashbord" src="https://github.com/user-attachments/assets/47032bf9-5ff4-47dc-93f9-6521f48d4e4e" />



<img width="1342" height="500" alt="granfan vm jenkins" src="https://github.com/user-attachments/assets/2afcbe48-8284-4e6b-8779-a665596953af" />



<img width="1719" height="784" alt="grafna 3" src="https://github.com/user-attachments/assets/959a5fa6-03b2-4377-9ad0-5760a16b1b18" />



<img width="1714" height="844" alt="pods avec namespaces" src="https://github.com/user-attachments/assets/e3576524-e85e-483d-82a0-a65a53a09fe6" />



<img width="1714" height="785" alt="network" src="https://github.com/user-attachments/assets/db7cb1c3-60aa-400a-8e13-fd80e2328187" />




<img width="1724" height="704" alt="grafana jenkins 2" src="https://github.com/user-attachments/assets/0a2f0f98-1e71-4d95-98a7-bd4fc81cf7a6" />




---

### 🔹 6. CI/CD with Jenkins Pipelines

The pipeline was **executed on the Jenkins Slave** in Azure.  

<img width="1704" height="545" alt="nodes sur jenkins" src="https://github.com/user-attachments/assets/c4d9c56a-9e51-48e6-bf99-79d773010c05" />


<img width="1720" height="921" alt="jenkinsFile1" src="https://github.com/user-attachments/assets/9bda5203-93bc-4ff3-949b-0a75e2b7581e" />



Pipeline stages (`Jenkinsfile`):  

1. **Clone repo from GitHub** 📂  

2. **Scan code with SonarQube** 🧪  


<img width="1716" height="920" alt="jenki2" src="https://github.com/user-attachments/assets/c3666ba5-90f7-4a68-b20d-0e7730c5ac82" />



<img width="1717" height="923" alt="sonor1" src="https://github.com/user-attachments/assets/0f496619-98a2-4f10-8b5d-33c10abeabda" />



<img width="1720" height="933" alt="sonor2" src="https://github.com/user-attachments/assets/eaf1976c-62a1-415c-b394-922636ede59c" />



3. **Build Docker image (with TMDB API key )** 🐳  


<img width="1716" height="920" alt="jenki2" src="https://github.com/user-attachments/assets/036da34b-f5ae-469b-9cc6-0ca97f8ed3de" />


4. **Scan Docker image with Trivy** 🔒  


<img width="1629" height="713" alt="trivy1" src="https://github.com/user-attachments/assets/331615bc-bba8-4414-8915-d9eb1ffbf137" />



<img width="1668" height="648" alt="trivy2" src="https://github.com/user-attachments/assets/7937a512-541d-495a-96e1-64738defd590" />




5. **Push Docker image to GitLab Registry** 📦  

<img width="1712" height="917" alt="jenkins3" src="https://github.com/user-attachments/assets/7f395e42-2148-44b1-96f6-c197dc3d1a53" />



<img width="1863" height="822" alt="imagesurgitLab" src="https://github.com/user-attachments/assets/bac9f6bb-29a5-4872-8cbd-79c569e0db19" />




6. **Update `dep.yml` in repo (for ArgoCD auto-sync)** ✏️  


<img width="1368" height="567" alt="update dep yml jenkins" src="https://github.com/user-attachments/assets/a9344857-e0e1-474e-957d-ebfb628e516e" />


<img width="1158" height="65" alt="update dep" src="https://github.com/user-attachments/assets/80fe274c-4ceb-4eec-a691-dd99e5ba4f5c" />

7. **Pipeline Success** ✅  

<img width="1381" height="393" alt="succ pipline" src="https://github.com/user-attachments/assets/699a5a14-8c8c-40f3-a0fa-0660d114d920" />



<img width="1712" height="919" alt="piplinejenkinsfinal" src="https://github.com/user-attachments/assets/01328ee4-1a28-4045-9b77-e696072a14d2" />





---

### 🔹 7. GitOps Deployment with ArgoCD

- **ArgoCD** was already installed via Ansible.  
- Configured to **auto-sync** with GitHub repo.  
- Every commit on `dep.yml` → automatic redeployment.  
- Application exposed externally via:  
  - **MetalLB** → External IP  
  - **NGINX Ingress** → Domain-based access
    
MetalLB Pods :


<img width="747" height="107" alt="metallab pods" src="https://github.com/user-attachments/assets/63e74c54-5ac3-412a-9429-d4fc55f3a375" />



NGINX Ingress Pods :


<img width="1273" height="210" alt="ingress pods" src="https://github.com/user-attachments/assets/a2ab8c3a-f734-4e75-961a-ea0b46ee22af" />

ArgoCD :


<img width="1718" height="928" alt="autosyncArgo" src="https://github.com/user-attachments/assets/0c34c460-4899-4403-bba7-7f80defbd25c" />



<img width="1718" height="922" alt="Argocfinal" src="https://github.com/user-attachments/assets/fa137123-7bbd-4b7c-8699-4a0ca9195b18" />




---

## 🎉 Final Result

Netflix Clone accessible at:  
🌍 **www.netflix-mohamed-aziz-benabbes.com**

<img width="1712" height="921" alt="siteFinal" src="https://github.com/user-attachments/assets/6ed55d98-b308-44bd-b791-c52885279df6" />



<img width="1718" height="942" alt="SiteFinal2" src="https://github.com/user-attachments/assets/625f34c2-a347-4443-95de-1c0be4bee4d0" />


---
🙏 Acknowledgements

Thank you to everyone who took the time to visit my GitHub and read through this project 🚀.
I am available for any questions or suggestions!

## 🙏 Remerciements

Merci à toutes les personnes qui ont pris le temps de visiter mon GitHub et de lire ce projet 🚀.  
Je suis disponible pour toutes vos **questions** ou **suggestions** !  

👤 **Mohamed Aziz Ben Abbes**  
📧 [benabbes.mohamedaziz30@gmail.com](mailto:benabbes.mohamedaziz30@gmail.com)  
