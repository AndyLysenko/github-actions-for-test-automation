# Wait for deployment action

## Inputs

Takes seven required input parameters:

- `project-name`: Name of the project (in other words, service) targeted for testing. Value is used to determine the list of tests responsible for verification of deployed service. . *Required*
- `docker-image`: Name(not tag!) of deployed image to be tested. It includes Url of Azure [Container Registry](https://azure.microsoft.com/en-us/products/container-registry), project name and docker-image-tag. *Required*
- `environment`: . Environment to run tests on. *Required*
- `argocd-test-access-token`: JWT to access ArgoCD test instance. It is a secret value, treat it responsibly. *Required*
- `argocd-prod-access-token`: JWT to access ArgoCD prod instance. It is a secret value, treat it responsibly. *Required*
- `deploy-wait-timeout`: Time to wait for image to be deployed in seconds. *Required*
- `deploy-wait-polling-interval`: An interval to poll ArgoCD API to check the deployment status. *Required*

**Always keep sensitive data in [encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)!**

## Outputs

- None

## What it does

This action:

- Depending on the environment picks ArgoCD server URL and access token
- Checks deployment status of specified `docker-image` on `environment` for `deploy-wait-timeout` period of time with `deploy-wait-polling-interval` interval

## How it works

The action uses:

- [ArgoCD API](https://cd.apps.argoproj.io/swagger-ui)
- PowerShell module `ArgoCD` located in ./script folder on action folder

The script polls [ArgoCD API](https://cd.apps.argoproj.io/swagger-ui) and waits for the specified image to be deployed and at least one healthy pod be present in the cluster.

## Sample usage

Wait for image `andylysenko.azurecr.io/service01:alf-2.2.0-develop.63.b310663f` of `service01` be deployed to `qa` environment:

```yaml
- name: Wait for deployment
  uses: andy-lysenko/api-integration-tests/.github/actions/wait-for-deployment@main
  with:
    project-name: service01
    docker-image: andylysenko.azurecr.io/service01:alf-2.2.0-develop.63.b310663f
    environment: qa
    argocd-test-access-token: ${{secrets.ARGOCD_TEST_ACCESS_TOKEN}}
    argocd-prod-access-token: ${{secrets.ARGOCD_PROD_ACCESS_TOKEN}}
    deploy-wait-timeout: 300
    deploy-wait-polling-interval: 10
```
