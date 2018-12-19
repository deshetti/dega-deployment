#!/usr/bin/env bash

kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=sa/fadepgad.json
kubectl create secret generic realm-secret --from-file=realm.json=keycloak/realm-config/jhipster-realm.json
helm install --name keycloak -f keycloak/values.yaml stable/keycloak