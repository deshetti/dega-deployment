    # Dega Deployment

## Pending
1. Using Namespaces in Kubernetes
2. Setup backups and restore mechanisms
3. Setting up SSL
4. Secure Helm/Tiller

## Steps before starting the deployment
To generate the missing Docker image(s), please run:
```
  ./gradlew bootWar -Pprod jibDockerBuild in /Users/deshetti/Projects/dega/dega-core
  ./gradlew bootWar -Pprod jibDockerBuild in /Users/deshetti/Projects/dega/dega-factcheck
  ./gradlew bootWar -Pprod jibDockerBuild in /Users/deshetti/Projects/dega/dega-gateway
```

You will need to push your image to a registry. If you have not done so, use the following commands to tag and push the images:
```
  docker image tag core gcr.io/dega-224221/core
  gcloud docker -- push gcr.io/dega-224221/core
  docker image tag factcheck gcr.io/dega-224221/factcheck
  gcloud docker -- push gcr.io/dega-224221/factcheck
  docker image tag gateway gcr.io/dega-224221/gateway
  gcloud docker -- push gcr.io/dega-224221/gateway
```

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

The [tutorial](https://codelabs.developers.google.com/codelabs/cloud-postgresql-gke-memegen/#0) explains the steps to connect to Cloud SQL from Kubernetes: 

1. Create Postgres Instance on Google Cloud SQL. You could get the connection name for the instance using the following command:
```
gcloud sql instances describe [DB Instance ID] | grep connectionName
```
2. Create a Database with the name keycloak
3. Create a service account with admin rights to the database


Following are some articles that provide more information on Kuberenetes:

[Creating secrets in Kubernetes](https://kubernetes.io/docs/concepts/configuration/secret/)

[Steps for connecting to Google Cloud SQL from Kuberenetes](https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine)

## Create Secrets required for Keycloak

Command to create a secret from the service account
```
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=sa/fadepgad.json
```

Command to create a realm secret from the jhipster-realm.json (the realm file includes the users as well)
```
kubectl create secret generic realm-secret --from-file=realm.json=keycloak/realm-config/jhipster-realm.json
```

Confirm the secret is created by the following command:

```
kubectl get secrets
```

## Install Keycloak

Following command installs the version 4.0.7 version of helm chart for keycloak. appVersion: 4.5.0.Final
```
helm install --name keycloak -f keycloak/values.yaml stable/keycloak --version 4.0.7
```

Following is the command to get the password for the keycloak instance:

```
kubectl get secret --namespace default keycloak-http -o jsonpath="{.data.password}" | base64 --decode; echo
```

## Install MongoDB

helm install --name mongo -f mongo/values.yaml stable/mongodb

## Increasing the number of replicas
kubectl scale statefulset mongo-mongodb-secondary --replicas=3
kubectl scale statefulset mongo-mongodb-primary --replicas=3

## Connect to MongoDB from outside the cluster
kubectl port-forward --namespace default svc/mongo-mongodb 27017:27017 & mongo --host 127.0.0.1 --authenticationDatabase admin -p $MONGODB_ROOT_PASSWORD

## Install Elasticsearch
helm install --name elasticsearch -f elasticsearch/values.yaml stable/elasticsearch

## Install Registry (Consul and more)
kubectl

## Delete Keycloak Instance

Following are the commands to delete the Keycloak installation from Kuberenetes:

```
helm delete keycloak
helm del --purge keycloak
```


keycloak JsaZdVBOrM
