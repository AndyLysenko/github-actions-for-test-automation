# Get KeyVault secrets

## Inputs

Takes four required input parameters:

- `keyvault-name`: Name of Key Vault in [AndyLysenko](https://portal.azure.com/#home) Azure Organization. *Required*
- `client-id`: Azure client ID who is eligible to read-access specified Key Vault. It is a secret value, treat it responsibly. *Required*
- `tenant-id`: Corresponding Azure tenant ID for access. It is a secret value, treat it responsibly. *Required*
- `subscription-id`: Corresponding Azure subscription ID for access. It is a secret value, treat it responsibly. *Required*

**Always keep sensitive data in [encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)!**

## Outputs

- None

## What it does

This action:

- Logs in to Azure with [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/what-is-azure-cli) using credentials provided in the input: `client-id`, `tenant-id`, `subscription-id`
- Fetches secrets from Key Vault specified in `keyvault-name` using [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/what-is-azure-cli). See the list if secrets below
- Creates environment variable and assignes a value for each fetched secret using [bash](https://www.gnu.org/software/bash/).

### List of secrets and environment variables

 Environment variable| Secret
:---|:---
 AppSettings__ConnectionDetails__Secret1  |  ado-keyvault-secret1
 AppSettings__ConnectionDetails__Secret2  |  ado-keyvault-secret2
 AppSettings__ConnectionDetails__Secret3  |  ado-keyvault-secret3

The list is hardcoded in the script.

## How it works

For every sectret from the above table an environment variale will be created and feteched value assigned, for example

```text
AppSettings__ConnectionDetails__Secret1 = valueyOf(ado-keyvault-secret1)
```

Double underscores will be parsed as a hierarchy level and the values will be mapped to corresponding properties of dotnet [appsetting.json]([appsettings.json](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-7.0)).

## Sample usage

Get secrest from keyvalut using permissions from GitHub Actions secrets:

```yaml
- name: Get secrets from Azure keyvault
  uses: AndyLysenko/api-integration-tests/.github/actions/get-keyvault-secrets@main
  with:
    keyvault-name: aks-qa
    client-id: ${{ secrets.AZURE_CLIENT_ID_platform_a_QA }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID_TEST }}
  timeout-minutes: 3
```
