#!/bin/bash

git clone https://github.com/vllm-project/production-stack.git
cd production-stack/utils

bash install-kubectl.sh
bash install-helm.sh
sudo apt remove minikube
bash install-minikube-cluster.sh
minikube status
kubectl describe nodes | grep -i gpu
kubectl run gpu-test --image=nvidia/cuda:12.2.0-runtime-ubuntu22.04 --restart=Never -- nvidia-smi
sleep 10
kubectl logs gpu-test

