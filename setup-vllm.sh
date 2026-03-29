#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-default}"
RELEASE="${RELEASE:-vllm}"
VALUES_FILE="${VALUES_FILE:-qwen3-coder-next.yaml}"
HF_SECRET_NAME="${HF_SECRET_NAME:-huggingface-credentials}"

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "HF_TOKEN is not set. Export HF_TOKEN before running this script."
  exit 1
fi

kubectl -n "${NAMESPACE}" create secret generic "${HF_SECRET_NAME}" \
  --from-literal=HUGGING_FACE_HUB_TOKEN="${HF_TOKEN}" \
  --dry-run=client -o yaml | kubectl apply -f -

helm repo add vllm https://vllm-project.github.io/production-stack
helm repo update

helm upgrade --install "${RELEASE}" vllm/vllm-stack \
  -n "${NAMESPACE}" \
  -f "${VALUES_FILE}"

kubectl -n "${NAMESPACE}" get pods
kubectl -n "${NAMESPACE}" get svc

# Wait for router service before port-forwarding.
kubectl -n "${NAMESPACE}" wait --for=condition=available --timeout=10m deployment/${RELEASE}-deployment-router
kubectl -n "${NAMESPACE}" port-forward svc/${RELEASE}-router-service 8000:80