#!bin/bash

NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="ExternalIP")].address }')
search="MY_NODE_IP"
filename="./terminal-application-deployment.yaml"
sed -i "s/$search/$NODE_IP/" $filename

kubectl apply -f ./terminal-application-deployment.yaml
kubectl apply -f ./service-terminal-application-lb.yaml