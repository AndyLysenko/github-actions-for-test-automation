# About

[<img align="right" width="300px" src="https://miro.medium.com/v2/resize:fit:1400/0*nPl_823wvgb6O2Hc.png" />](https://docs.github.com/en/actions)

This repository contains composite GitHub Actions regarding test automation and real life examples of GitHub workflows.

# Contents

## Actions
Composite actions folder:
- `compose-test-filter` - build overal test filter
- `get-keyvault-secrets`- fetch secrets from Azure KeyVault
- `run-tests` - run tests with *dotnet test*
- `trigger-tests-after-deployment` - trigger test workflow from another repository
- `create-opsgenie-alert` - create custom alert in [OpsGenie](https://www.atlassian.com/software/opsgenie)
- `wait-for-deployment` - composite action to wait for [Argo CD](https://argo-cd.readthedocs.io/en/stable/) deployment to finish

## Workflows
Reusable workflows:
- `nightly-pl-a-all-qa.yaml` - workflows definition to run all tests for platform_a
- `nightly-pl-b-all-qa.yaml` - workflows definition to run all tests for platform_b
- `on-demand.yaml` - workflows definition for manual test run. Contains all possible filters
- `pr-validate.yaml` - workflow to validate a PR
- `run-tests-tmpl.yaml` - template used to run tests by all workflows
- `test-deployment.yaml` - workflows definition to run tests after a service has been deployed

# What it does
All workflows more or less go through the same flow:
1. Pulls the repo
2. Calculates the variables
3. Installs required version of dotnet
4. Fetches secrets from Azure KeyVault
5. Restores the solution
6. Runs test with *dotnet test*
7. Publishes test results
8. Sends email report with run highlights
9. Publishes html test report as a run artifact
10. Sends and alert to [OpsGenie](https://www.atlassian.com/software/opsgenie)

# Information
More information about [GitHub Actions ](https://docs.github.com/en/actions). <br />
More information about [OpsGenie alerts](https://www.atlassian.com/software/opsgenie). <br />
More information about [Argo CD](https://argo-cd.readthedocs.io/en/stable/).