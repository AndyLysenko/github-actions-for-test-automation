# Create OpsGenie alert action

## Inputs

Takes fifteen input parameters, where two are required:

- `message`: Message of the alert. In other words, a subject or a summary.  *Required*
- `alias`: Client-defined identifier of the alert, that is also the key element of Alert [De-Duplication](https://support.atlassian.com/opsgenie/docs/what-is-alert-de-duplication/). *Optional*
- `description`: Description field of the alert that is generally used to provide a detailed information about the alert. *Optional*
- `responders`: Teams, users, escalations and schedules that the alert will be routed to send notifications. *type* field is mandatory for each item, where possible values are **team, user, escalation** and **schedule**. If the API Key belongs to a team integration, this field will be overwritten with the owner team. Either **id** or **name** of each responder should be provided. You can refer below for example values. See examples below. *Optional*
- `visible-to`: Teams and users that the alert will become visible to without sending any notification. *type* field is mandatory for each item, where possible values are **team** and **user**. In addition to the *type* field, either **id** or **name** should be given for teams and either id or username should be given for users. Please note: that alert will be visible to the teams that are specified within *responders* field by default, so there is no need to re-specify them within *visibleTo* field. You can refer below for example values. See examples below. *Optional*
- `actions`: Custom actions that will be available for the alert. Common actions like Close or Ack will be added by default. *Optional*
- `tags`: Tags of the alert. Useful for filtering and search. Should be specified in json array string with escaped double quotes. **Example:** tags: '[\\"ta\\", \\"${{inputs.project-name}}\\"]' . *Optional*
- `details`: Map of key-value pairs to use as custom properties of the alert. Should be specified in json object string with escaped double quotes. **Example:** '{ \\"run-status\\": \\"success\", \\"environment\\": \\"${{inputs.environment}}\\" }' *Optional*
- `entity`: Entity field of the alert that is generally used to specify which domain alert is related to. *Optional*
- `source`: Source field of the alert. Default value is IP address of the incoming request. *Optional*
- `priority`: Priority level of the alert. Possible values are P1, P2, P3, P4 and P5. Default value is P3. *Optional*
- `user`: Display name of the request owner. *Optional*
- `note`: Additional note that will be added while creating the alert. In other words, a comment. *Optional*
- `opsgenie-api-key`: API key for specific OpsGenie integration. This key will be used not only for authorization, but also for setting owner and responsible team. It is a secret value, treat it responsibly. *Required*
- `use-eu-opsgenie-instance`: Whether to use EU OpsGenie instance or not. EU instance a has slightly different URL. Defaulted to false. *Optional*

**Always keep sensitive data in [encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)!**

## Outputs

- None

## What it does

This action:

- Validates input parameters
- Using OpsGenie [Alert API](https://docs.opsgenie.com/docs/alert-api) creates alert for an integration specified by `opsgenie-api-key`
- Validates response and logs requestId, since Alert API works asynchronously

## Sample usage

Create alert after workflow run has finished:

```yaml
- name: Create alert in OpsGenie
  uses: andy-lysenko/api-integration-tests/.github/actions/create-opsgenie-alert@main
  with:
    message: "[${{needs.run-tests.result}}] Tests [${{inputs.project-name}}] on [${{inputs.environment}}] image [${{inputs.docker-image-tag}}]"
    alias: ${{github.run_id}}
    description: 'Test run url: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}'
    tags: '[\"ta\", \"${{inputs.project-name}}\"]'
    details: '{\"run-status\": \"${{needs.run-tests.result}}\", \"environment\": \"${{inputs.environment}}\", \"github_run_id\": \"${{github.run_id}}\", \"service\": \"${{inputs.project-name}}\", \"github_repository\": \"${{github.repository}}\", \"github_ref\": \"${{github.ref}}\", \"github_workflow_ref\": \"${{github.workflow_ref}}\", \"github_event_name\": \"${{github.event_name}}\", \"github_actor\": \"${{github.actor}}\", \"github_sha\": \"${{github.sha}}\" }'
    entity: github-actions
    source: ${{ github.server_url }}
    priority: ${{needs.run-tests.result == 'success' && 'P5' || 'P3'}}
    user: ${{github.actor}}
    opsgenie-api-key: ${{secrets.OPSGENIE_GITHUB_QA_API_KEY}}
```

### Responders input example

```json
{
  "responders":[
    {
      "id":"4513b7ea-3b91-438f-b7e4-e3e54af9147c",
      "type":"team"
    },
    {
      "name":"NOC",
      "type":"team"
    },
    {
      "id":"bb4d9938-c3c2-455d-aaab-727aa701c0d8",
      "type":"user"
    },
    {
      "username":"trinity@opsgenie.com",
      "type":"user"
    },
    {
      "id":"aee8a0de-c80f-4515-a232-501c0bc9d715",
      "type":"escalation"
    },
    {
      "name":"Nightwatch Escalation",
      "type":"escalation"
    },
    {
      "id":"80564037-1984-4f38-b98e-8a1f662df552",
      "type":"schedule"
    },
    {
      "name":"First Responders Schedule",
      "type":"schedule"
    }
  ]
}
```

### VisibleTo input example

```json
{
  "visibleTo":[
    {
      "id":"4513b7ea-3b91-438f-b7e4-e3e54af9147c",
      "type":"team"
    },
  {
      "name":"rocket_team",
      "type":"team"
    },
    {
      "id":"bb4d9938-c3c2-455d-aaab-727aa701c0d8",
      "type":"user"
    },
    {
      "username":"trinity@opsgenie.com",
      "type":"user"
    }
  ]
}
```
