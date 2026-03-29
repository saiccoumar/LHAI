#!/bin/bash
set -e

# Install minikube 
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

# Check for NVIDIA driver
if ! command -v nvidia-smi &> /dev/null; then
    echo "[ERROR] NVIDIA driver not found. Install NVIDIA drivers first."
    exit 1
else
    echo "[INFO] NVIDIA driver detected:"
    nvidia-smi
fi

# Check bpf_jit_harden
BPF_JIT=$(sudo sysctl -n net.core.bpf_jit_harden)
echo "[INFO] Current net.core.bpf_jit_harden: $BPF_JIT"
if [ "$BPF_JIT" -ne 0 ]; then
    echo "[INFO] Setting net.core.bpf_jit_harden=0"
    echo "net.core.bpf_jit_harden=0" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
fi

# Check if NVIDIA Container Toolkit runtime is already configured for Docker
if command -v nvidia-ctk &> /dev/null; then
    if nvidia-ctk runtime list | grep -q "docker"; then
        echo "[INFO] NVIDIA Container Toolkit already configured for Docker runtime, skipping."
    else
        echo "[INFO] Configuring NVIDIA Container Toolkit for Docker runtime"
        sudo nvidia-ctk runtime configure --runtime=docker
        sudo systemctl restart docker
    fi
else
    echo "[WARNING] nvidia-ctk not found. Make sure NVIDIA Container Toolkit is installed."
fi

# Optional: delete existing minikube instance
echo "[INFO] Deleting existing Minikube cluster (if any)"
minikube delete || true

# Start minikube with GPU support (using NVIDIA Container Toolkit)
echo "[INFO] Starting Minikube with Docker driver and GPU support"
minikube start --driver=docker --container-runtime=docker --gpus all

sudo snap install kubectl --classic
echo "[INFO] Minikube started successfully. Check nodes:"
kubectl get nodes -o wide

echo "[INFO] To use host Docker images inside Minikube, run:"
echo "  eval \$(minikube docker-env)"