# argocd-crd-crashloopbackoff

## Description

Script to reproduce argocd-application-controller crashloopbackoff with a k8s cluster with more than 200 CRD.

## Prerequisites

- [kind](https://kind.sigs.k8s.io/) >= 0.7.0
- kubectl >= 1.15
- Git

## How to

Clone this repository.

```bash
cd <CLONED REPOSITORY>

KIND_NAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
K8S_VERSION="1.15.7"
WAIT_TIME=5

kind create cluster --name ${KIND_NAME} --config cluster.yaml --image kindest/node:v${K8S_VERSION}

kubectl create ns argocd

kubectl config set-context --namespace argocd kind-${KIND_NAME}

kubectl apply -k argocd

kubectl wait --for=condition=Ready -l app.kubernetes.io/name=argocd-server pod --timeout=300s

kubectl apply -f crds

kubectl get pod --watch
```

Wait until argocd go to crashloopbackoff

## Test correction

[Alexmt](https://github.com/alexmt) did a PR to correct this problem [here](https://github.com/argoproj/argo-cd/commit/7fd7999e49be09dde59e48cdd318a98e12c69317)

Here the procedure to test the correction:

```bash
cd <CLONED REPOSITORY>

KIND_NAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
K8S_VERSION="1.15.7"
WAIT_TIME=5

kind create cluster --name ${KIND_NAME} --config cluster.yaml --image kindest/node:v${K8S_VERSION}

kubectl create ns argocd

kubectl config set-context --namespace argocd kind-${KIND_NAME}

kubectl apply -k argocd-correction

kubectl wait --for=condition=Ready -l app.kubernetes.io/name=argocd-server pod --timeout=300s

kubectl apply -f crds

kubectl get pod --watch
```

## Clean Up

```bash
kind delete cluster --name ${KIND_NAME}
```
