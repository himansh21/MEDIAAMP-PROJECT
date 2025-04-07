# MEDIAAMP-PROJECT
# DevOps Internship Challenge – Final Report

## Project Title
**Infrastructure Automation & Monitoring with Proxmox, Terraform, Jenkins, and Prometheus**

## Overview
This project simulates a real-world DevOps deployment scenario by combining tools like Proxmox, Terraform, Jenkins, and Prometheus. It covers infrastructure provisioning, networking, automated application deployment, and monitoring.

## Tools & Stack
| Tool            | Usage                                               |
|-----------------|-----------------------------------------------------|
| Proxmox         | Virtualization platform for VMs and containers     |
| VMware          | Used as the base hypervisor for running Proxmox    |
| Ubuntu Server   | Base OS for VM and container environments          |
| Terraform       | Infrastructure provisioning and automation         |
| Jenkins         | CI/CD pipeline for application deployment          |
| Prometheus      | Monitoring solution for metrics and observability  |

---

## Step 1: Proxmox Environment Initialization
- Proxmox VE was installed and set up using a bootable USB drive.
- Since the hardware environment had limitations, NAT networking was configured instead of a bridged connection.
- Proxmox's default bridge `vmbr0` was adapted for NAT-based access.

## Step 2: Provisioning VM & LXC via Terraform
- A Terraform script was used to automate VM and container creation on Proxmox.

### Virtual Machine Configuration
- OS: Ubuntu Server 22.04
- Assigned static IP: `10.0.0.100`
- SSH enabled and tested

### Container Configuration
- Type: LXC (Ubuntu-based, privileged)
- Assigned static IP: `10.0.0.101`
- Internet access and intra-network communication verified

---

## Step 3: Internal Networking
- NAT-based virtual networking was configured using `vmbr0`.
- IP Assignments:
  - VM: `10.0.0.100`
  - Container: `10.0.0.101`
- Verified communication:
  - VM ↔ LXC
  - VM → Internet
  - LXC → Internet

---

## Step 4: Flask Application Deployment
- A minimal Flask app was developed with two endpoints:
  - `/` returns "Hello World from [Name]"
  - `/compute` performs CPU-intensive logic (e.g., Fibonacci calc)
- Required files:
  - `app.py`
  - `requirements.txt`
- App tested using `python3 app.py` on port 5000

---

## Step 5: Automating Flask with Crontab
To ensure the app starts automatically and stays alive:

### Script Creation
```bash
#!/bin/bash
cd /home/ubuntu/flask_app
/usr/bin/python3 app.py >> flask_output.log 2>&1
```
- File saved as `start_flask.sh` and made executable

### Cron Job Setup
- Added to crontab using `crontab -e`:
```bash
*/5 * * * * /home/ubuntu/start_flask.sh
```
- Ensures app is triggered every 5 minutes

---

## Step 6: CI/CD Pipeline via Jenkins

### Jenkins Setup
- Jenkins installed on VM
- New pipeline job created linked to GitHub repo

### Jenkinsfile Tasks
- Clone repo
- Create virtual environment
- Install dependencies
- Restart the Flask app
- Send test request to root endpoint

### Outcome
- Ensures reproducible deployments
- Simplifies application updates with a single commit

---

## Step 7: Prometheus-Based Monitoring

### Setup
- Prometheus installed on separate container
- Configured to scrape from:
  - Node Exporter (system metrics)
  - Flask app (via `prometheus_flask_exporter`)

### Metrics Tracked
- CPU and memory usage
- Application request count and latency

---

## Final Directory Structure (GitHub)
```bash
.
├── flask_app/
│   ├── app.py
│   ├── requirements.txt
├── terraform/
│   ├── main.tf
├── jenkins/
│   ├── Jenkinsfile
├── monitoring/
│   ├── prometheus.yml
│   ├── node_exporter_config/
├── scripts/
│   ├── start_flask.sh
├── README.md
```

## Summary
This project offers a complete hands-on DevOps workflow with automation, observability, and application deployment from scratch. The goal was to simulate production-grade practices on a personal or learning infrastructure using open-source tools.

