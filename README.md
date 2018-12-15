# Dega Deployment

## Enable APIs

Enable the following APIs on Google Cloud Console:

Cloud Shell API
Google Cloud SQL Admin API
Google Container Registry API
Google Kubernetes Engine API

## Install Helm
```
sh helm/add_helm.sh
```

## Connect to Postgres

The tutorial explains the steps to connect t

1. Create Postgres Instance on Google Cloud SQL. You could get the connection name for the instance using the following command:
```
gcloud sql instances describe [DB Instance ID] | grep connectionName
```
2. Create a Database with the name keycloak



Create secret using the following command:

```
kubectl create -f secrets/postgres.yaml
```

Confirm the secret is created by the following command:

```
kubectl get secrets
```

Following are some articles that provide more information on Kuberenetes:

[Creating secrets in Kubernetes](https://kubernetes.io/docs/concepts/configuration/secret/)

[Steps for connecting to Google Cloud SQL from Kuberenetes](https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine)

## Install Keycloak
```
helm install --name keycloak -f keycloak/values.yaml stable/keycloak
```

Following is the command to get the password for the keycloak instance:

```
kubectl get secret --namespace default keycloak-http -o jsonpath="{.data.password}" | base64 --decode; echo
```

Command to create a secret from the service account
```
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=sa/fadepgad.json
```

Command to create a realm secret from the jhipster-realm.json (the realm file includes the users as well)
```
kubectl create secret generic realm-secret --from-file=realm.json=keycloak/realm-config/jhipster-realm.json
```

keycloak 75L7axQQWt

helm install --name keycloak -f keycloak/values.yaml stable/keycloak -Dkeycloak.migration.action=import -Dkeycloak.migration.provider=dir -Dkeycloak.migration.dir=keycloak/realm-config -Dkeycloak.migration.strategy=IGNORE_EXISTING