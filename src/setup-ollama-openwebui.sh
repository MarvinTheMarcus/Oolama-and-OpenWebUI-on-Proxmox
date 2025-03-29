#!/bin/bash

set -e

echo "🟢 Enter OpenWebUI Container ID (e.g., 110)"
read -p "> " OPENWEBUI_CONTAINER_ID

echo "🌐 Enter Proxmox Host IP (for Ollama API)"
read -p "> " OLLAMA_IP

echo "🤖 Choose a model to pull:"
MODELS=("llama2:7b" "mistral:7b" "codellama:13b" "gemma:7b" "custom (enter manually)")
select MODEL in "${MODELS[@]}"; do
  case $MODEL in
    "custom (enter manually)")
      read -p "Enter model name (e.g., llama2:13b): " CUSTOM_MODEL
      OLLAMA_MODEL="$CUSTOM_MODEL"
      break
      ;;
    *)
      OLLAMA_MODEL="$MODEL"
      break
      ;;
  esac
done

OLLAMA_PORT="11434"
OLLAMA_URL="http://${OLLAMA_IP}:${OLLAMA_PORT}"
OPENWEBUI_CONFIG_PATH="/root/.config/open-webui/config.json"

echo "----------------------------------------"
echo "🧩 Configuration Summary:"
echo " - OpenWebUI Container ID: $OPENWEBUI_CONTAINER_ID"
echo " - Proxmox Host IP: $OLLAMA_IP"
echo " - Ollama Model: $OLLAMA_MODEL"
echo "----------------------------------------"
sleep 2

echo "🧹 Cleaning duplicate Proxmox repo entries..."
rm -f /etc/apt/sources.list.d/pve-install-repo.list
rm -f /etc/apt/sources.list.d/pve-no-subscription.list
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
apt update

echo "📥 Installing Ollama..."
apt install -y curl
curl -fsSL https://ollama.com/install.sh | sh
systemctl start ollama
systemctl enable ollama

echo "🧠 Pulling model: $OLLAMA_MODEL ..."
ollama pull "$OLLAMA_MODEL"

echo "✅ Ollama installed and model pulled."

echo "🔌 Connecting OpenWebUI (CT $OPENWEBUI_CONTAINER_ID) to Ollama..."

pct exec $OPENWEBUI_CONTAINER_ID -- bash -c "
  apt update && apt install -y jq
  mkdir -p \$(dirname \"$OPENWEBUI_CONFIG_PATH\")
  touch $OPENWEBUI_CONFIG_PATH
  if [ -s $OPENWEBUI_CONFIG_PATH ]; then
    jq --arg url \"$OLLAMA_URL\" '.ollama_url = \$url' $OPENWEBUI_CONFIG_PATH > /tmp/config.json && mv /tmp/config.json $OPENWEBUI_CONFIG_PATH
  else
    echo \"{\\\"ollama_url\\\": \\\"$OLLAMA_URL\\\"}\" > $OPENWEBUI_CONFIG_PATH
  fi
"

echo "🔁 Restarting OpenWebUI container..."
pct restart $OPENWEBUI_CONTAINER_ID

echo "🎉 DONE!"
echo "🌐 OpenWebUI is now connected to Ollama at $OLLAMA_URL"
