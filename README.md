# Dega Deployment

## Install Helm
```
sh helm/add_helm.sh
```

## Install Keycloak
```
helm install --name keycloak -f keycloak/values.yaml stable/keycloak
```

Following is the command to get the password for the keycloak instance:

```
kubectl get secret --namespace default keycloak-http -o jsonpath="{.data.password}" | base64 --decode; echo
```
