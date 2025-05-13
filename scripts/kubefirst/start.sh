#!/bin/bash

k3d cluster start  docondee-cluster

echo "Waiting for Kubefirst to provision the cluster (this may take 7-15 minutes)..."
echo "Waiting for cluster nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=10m || { echo "Nodes not ready after 10 minutes"; exit 1; }

# Verify cluster status
kubectl get nodes

# Export kubeconfig for OpenLens setup
echo "Exporting kubeconfig for OpenLens..."
k3d kubeconfig get kubefirst > kubeconfig.yaml
echo "Kubeconfig exported to kubeconfig.yaml."
