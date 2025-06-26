#!/bin/bash

echo "Building image with Kaniko in Minikube..."

# Apply the kaniko pod
kubectl apply -f kaniko.yaml

# Wait for the pod to complete
echo "Waiting for build to complete..."
kubectl wait --for=condition=Ready pod/kaniko-build --timeout=300s

# Check if build was successful
if kubectl get pod kaniko-build -o jsonpath='{.status.phase}' | grep -q "Succeeded"; then
    echo "Build successful! Pulling image to local Docker..."
    
    # Get minikube IP
    MINIKUBE_IP=$(minikube ip)
    
    # Pull the image from minikube registry to local Docker
    docker pull $MINIKUBE_IP:5000/whatismyip:latest
    
    # Tag it for local use
    docker tag $MINIKUBE_IP:5000/whatismyip:latest whatismyip:latest
    
    echo "Image successfully pulled and tagged as whatismyip:latest"
    echo "You can now run: docker run whatismyip:latest"
else
    echo "Build failed. Check logs with: kubectl logs kaniko-build"
    kubectl logs kaniko-build
fi

# Clean up the pod
echo "Cleaning up..."
kubectl delete -f kaniko.yaml 