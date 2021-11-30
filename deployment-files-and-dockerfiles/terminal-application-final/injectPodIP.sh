#!bin/bash

# Get and filter out the external node IP address
NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="ExternalIP")].address }')
# We use the value we get from the above command to replce the TRUE_POD_IP variable in deployment file
sed -i "s/TRUE_POD_IP/$NODE_IP/" ./terminal-application-deployment.yaml

kubectl apply -f ./terminal-application-deployment.yaml
kubectl apply -f ./service-terminal-application-lb.yaml