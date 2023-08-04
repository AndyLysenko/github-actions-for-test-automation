# Compose test filter action

## Inputs

Takes four input parameters, where two are required and two are optional with a reasonable default:

- `priority`: Priority of the tests to be filtered out. Currently supported: `Critical`, `Normal` or `All`. *Required*
- `hardware-platform`: Hardware platform to target by the tests. Currently supported: `platform_a`, `platform_b` or `All`. *Required*
- `test-id`: Option to filter tests by `'TestId'` trait attribute, every test is decorated with (e.g. `IDA001`). `'Like ~'` operator will be applied to provided value, it means template can be specified (e.g. `IDA` or `IDA00`). Has a default of `empty` value, which will run all the tests. *Optional*
- `service`: Service to target by the tests. *Optional*

## Outputs

Yields single output parameter:

- `test-filter`: Overall test filter composed of multiple input trait filters. All input filters are combined by `'and'` logical operator: `'<priority_filter> & <hardware_filter> & <test_id_filter>' & <service_filter>`

## What it does

This action takes four input filters and combines those into one resulting filter ready to be used by `'dotnet test'` cli command. Every input value corresponds to a trait attribute in test framework.

## How it works

- `priority`: Input value is transformed to `'Priority=<input value>'`. If `All` is specified, output will be `'.'`, which means `'no filter'`
- `hardware-platform`: Input value is transformed to `'Platform=<input value>'`. If `'All'` is specified, output will be `'.'`, which means `'no filter'`
- `test-id`: Input value is transformed to `'TestId~<input value>'`. If `'empty'` value is specified, output will be `'.'`, which means `'no filter'`
- 'service': Input value is transformed to `'Service=<input value>'`. If `'All'` is specified, output will be `'.'`, which means `'no filter'`
See sample usages below.

## Sample usage

Here are some examples:

### Run all tests

```yaml
compose-test-filter:
  runs-on: ubuntu-latest
  steps:
    - name: Compose overall test filter
      id: compose-test-filter
      uses: AndyLysenko/api-integration-tests/.github/actions/compose-test-filter@main
      with:
        priority: All
        hardware-platform: All
  outputs:
    test-filter: ${{ steps.compose-test-filter.outputs.test-filter}}
```

Output:

```text
. & . & .
```

### Run Critical platform_b tests

```yaml
  compose-test-filter:
    runs-on: ubuntu-latest
    steps:
      - name: Compose overall test filter
        id: compose-test-filter
        uses: AndyLysenko/api-integration-tests/.github/actions/compose-test-filter@main
        with:
          priority: Critical
          hardware-platform: platform_b
    outputs:
      test-filter: ${{ steps.compose-test-filter.outputs.test-filter}}
```

Output:

```text
Priority=Critical & Platform=platform_b & .
```

### Run platform_a Contract tests

Normal test for Contract service have Test Id starting with `'ID'`, like `'IDA002a'`.

```yaml
  compose-test-filter:
    runs-on: ubuntu-latest
    steps:
      - name: Compose overall test filter
        id: compose-test-filter
        uses: AndyLysenko/api-integration-tests/.github/actions/compose-test-filter@main
        with:
          priority: Normal
          hardware-platform: platform_a
          test-id: ID
    outputs:
      test-filter: ${{ steps.compose-test-filter.outputs.test-filter}}
```

Output:

```text
Priority=Normal & Platform=platform_a & TestId~ID
```
