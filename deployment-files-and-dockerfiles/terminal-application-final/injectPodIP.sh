#!bin/bash

NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="ExternalIP")].address }')
sed -i "s/MY_NODE_IP/$NODE_IP/" ./terminal-application-deployment.yaml

kubectl apply -f ./terminal-application-deployment.yaml
kubectl apply -f ./service-terminal-application-lb.yaml