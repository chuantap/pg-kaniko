- install minikube and add the addons registry and ingress
'''
minikube addons enable registry
minikube addons enable ingress
'''
- install cert manager and cert manager issuer, check the .yaml. Needed to create TLS cert for HTTPS ingress
- install the ingress manifest
- export the ca cert created for the ingress by the cert manager issuer from the kubernetes secret and add it to trust store of minikube
'''
mkdir -p $HOME/.minikube/certs
cp my_company.pem $HOME/.minikube/certs/my_company.pem
minikube stop
minikube start --embed-certs
'''
- add hosts file entry for the registry hostname and IP of the ingress controller
'''
minikube ssh
echo "10.102.193.8 registry.local.test" | sudo tee -a /etc/hosts #lost after a restart
'''
- install the kaniko-build manifest. Make sure to have the registry hostname and IP of the ingress controller in the hostAliases
- install the app manifest.