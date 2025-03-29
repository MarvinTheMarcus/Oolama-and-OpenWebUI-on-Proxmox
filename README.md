# 🪐 Oolama + OpenWebUI Automated Setup on Proxmox

This repository contains an automated setup tool and `.deb` installer to easily install **Ollama** and connect it to **OpenWebUI** on a **Proxmox host**.

It will:
- Clean up duplicate Proxmox APT sources
- Install Ollama locally on your Proxmox node
- Pull your selected AI model (Llama2, Mistral, CodeLlama, or custom)
- Automatically configure OpenWebUI to connect to Ollama’s API

## 🚀 Features
✅ Proxmox-ready  
✅ Fully interactive (asks for container ID, host IP, model choice)  
✅ Installs and configures everything in one step  
✅ Includes `.deb` package for easy reinstallation  
✅ Safe for production or home lab use

## 📥 Installation

### 1. Clone this Repository
```bash
git clone https://github.com/MarvinTheMarcus/Oolama-and-OpenWebUI-on-Proxmox.git
cd Oolama-and-OpenWebUI-on-Proxmox
```

### 2. Build the `.deb` Package
```bash
dpkg-deb --build proxmox-ollama-openwebui-setup
```

### 3. Install
```bash
dpkg -i proxmox-ollama-openwebui-setup.deb
```

## ⚙️ What the Installer Will Do
During installation, you will be prompted to enter:
1. **Your OpenWebUI container ID (e.g., 110)**
2. **Your Proxmox Host IP address**
3. **Which AI model you want to pull** (pre-defined or custom)

Example model options:
- `llama2:7b`
- `mistral:7b`
- `codellama:13b`
- `gemma:7b`
- Custom model of your choice

## 🌐 OpenWebUI API Connection
Once the script runs, your OpenWebUI will be automatically configured to connect to:
```
http://<Proxmox-Host-IP>:11434
```
You can immediately start chatting via OpenWebUI after the setup completes.

## 📂 Project Structure
```
proxmox-ollama-openwebui-setup/
├── debian/                  # Debian package configs
├── src/                     # Source setup script
├── README.md                # This file
└── proxmox-ollama-openwebui-setup.deb (after build)
```

## 💡 Future Enhancements
- GitHub Actions pipeline for auto-building `.deb`
- Optional NVIDIA GPU passthrough setup
- Model download progress indicator
- Integration with multiple containers

## 🔥 License
This project is provided as-is. Use freely for private and lab environments.
