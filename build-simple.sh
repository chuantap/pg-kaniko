#!/bin/bash

echo "Building image with Kaniko in Minikube..."

# Apply the kaniko pod
kubectl apply -f kaniko.yaml

# Wait for the pod to complete
echo "Waiting for build to complete..."
kubectl wait --for=condition=Ready pod/kaniko-build --timeout=300s

# Check build status
if kubectl get pod kaniko-build -o jsonpath='{.status.phase}' | grep -q "Succeeded"; then
    echo "✅ Build successful!"
    echo "Image is now available in Minikube registry as: localhost:5000/whatismyip:latest"
    echo ""
    echo "To run it in Kubernetes, use:"
    echo "kubectl run whatismyip --image=localhost:5000/whatismyip:latest"
else
    echo "❌ Build failed. Check logs:"
    kubectl logs kaniko-build
fi

# Clean up the pod
echo "Cleaning up..."
kubectl delete -f kaniko.yaml 