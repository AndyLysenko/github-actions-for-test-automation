# Trigger integration tests action

## Inputs

Takes four required input parameters:

- `project-name`: Name of the project (in other words, service) targeted for testing. Value is used to determine the list of tests responsible for verification of deployed service. This value usually is a name of the repo in GitHub. *Required*
- `docker-image-tag`: Tag of deployed image to be tested. *Required*
- `environment`: Environment to run tests on. *Required*
- `test-repository-credentials-token`: GitHub token with permissions to trigger workflows located in another repository. Default one does not have such permissions. It is a secret value, treat it responsibly. *Required*

**Always keep sensitive data in [encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)!**

## Outputs

- None

## What it does

This action creates a GitHub workflow dispatch event with parameters combined from action inputs. More about [Events that trigger workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)

**This action only triggers automated test workflow and does not execute tests itself!**

## How it works

The action uses:

- `test-repository-credentials-token` to have permissions to post workflow dispatch event to different repo
- [GitHub REST API](https://docs.github.com/en/rest?apiVersion=2022-11-28)
- [actions/github-script](https://github.com/actions/github-script) to wrap the call and send API request

Since the action is to be used inside the organization, following parameters are hardcoded in the script:

```javascript
{
  owner: 'AndyLysenko',
  repo: 'api-integration-tests',
  workflow_id: 'test-deployment.yaml',
  ref: 'main'
}
```

Following parameters are forwarded from action imputs:

```javascript
{
  project-name: '${{ inputs.project-name }}',
  docker-image-tag: '${{ inputs.docker-image-tag }}',
  acr-registry-url: '${{ inputs.acr-registry-url }}',
  environment: '${{ inputs.environment }}',
  deploy-wait-timeout: '${{ inputs.deploy-wait-timeout }}',
  deploy-wait-polling-interval: '${{ inputs.deploy-wait-polling-interval }}'
}
```

## Sample usage

Trigger tests for `service01` on `staging` environment:

```yaml
- uses: AndyLysenko/api-integration-tests/.github/actions/trigger-tests-after-deployment@main
  with:
    project-name: service01
    docker-image-tag: image-2.2.0-develop.54.b8f4c38e
    acr-registry-url: acr.azurecr.io
    environment: staging
    deploy-wait-timeout: 300
    deploy-wait-polling-interval: 10
    test-repository-credentials-token: ${{ steps.deploySteps.outputs.github-app-installation-access-token }}
```
