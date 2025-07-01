- install minikube and add the addons registry and ingress
``` shell
minikube addons enable registry
minikube addons enable ingress
```
- install cert manager and cert manager issuer, check the .yaml. This is needed to create TLS certs for HTTPS ingresses
- install the ingress manifest
- export the ca root cert created by the cert manager issuer from the kubernetes secret and add it to the trust store of minikube
``` shell
kubectl get secret root-secret -n cert-manager -o jsonpath='{.data.ca\.crt}' | base64 -d > cert_manager_root_ca.pem
cp cert_manager_root_ca.pem $HOME/.minikube/certs/cert_manager_root_ca.pem
minikube stop
minikube start --embed-certs
```
- add hosts file entry for the registry hostname and IP of the ingress controller
``` shell
minikube ssh
echo "10.102.193.8 registry.local.test" | sudo tee -a /etc/hosts #lost after a restart
```
- install the kaniko-build manifest. Make sure to have the registry hostname and IP of the ingress controller in the hostAliases
- install the app manifest.