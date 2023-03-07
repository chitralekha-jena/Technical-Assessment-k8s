#!/bin/bash

# set the URL for the API endpoint
auth_url="https://151dd0e4-bd8b-453b-a01c-924e75053a8b.mock.pstmn.io/auth"

# make a curl request to the auth API endpoint and store the response in a variable
token=$(curl -s $auth_url | jq -r '.token')

# set the URL for the API endpoint
param_url="https://151dd0e4-bd8b-453b-a01c-924e75053a8b.mock.pstmn.io/parameters"

# make a curl request to the API endpoint, passing the token as an HTTP GET parameter
response=$(curl -s "${param_url}?TOKEN=${token}")

# extract PARAMETER1 and PARAMETER2 from the response using jq
PARAMETER1=$(echo $response | jq -r '.PARAMETER1')
PARAMETER2=$(echo $response | jq -r '.PARAMETER2')

# Create Kubernetes deployment YAML file
cat <<EOF > helloworld-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloworld-deployment
  labels:
    app: helloworld
spec:
  replicas: 1
  selector:
    matchLabels:
      app: helloworld
  template:
    metadata:
      labels:
        app: helloworld
    spec:
      containers:
      - name: helloworld
        image: hello-world:latest
        command: ["sh", "-c", "echo 'HELLO WORLD, $PARAMETER1 - $PARAMETER2'"]
        env:
        - name: PARAMETER1
          value: "$PARAMETER1"
        - name: PARAMETER2
          value: "$PARAMETER2"
          ports:
        - containerPort: 8080

EOF

# Apply the Kubernetes deployment YAML to the cluster
kubectl apply -f helloworld-deployment.yaml
