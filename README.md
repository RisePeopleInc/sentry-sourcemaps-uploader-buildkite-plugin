# Sentry Source Maps Uploader Buildkite Plugin

This plugin is used to upload sourcemaps to Sentry as private sourcemaps.

## Example

To generate a sentry auth token, see https://docs.sentry.io/cli/configuration/

Add the following to your `pipeline.yml`:

```yml

steps:
  - label: Upload Private SourceMaps to Sentry
    plugins:
      - RisePeopleInc/sentry-sourcemaps-uploader#v1.1.0:
          release_name: $BUILDKITE_COMMIT
          sourcemaps_artifact: sourcemaps/*
          auth_token: $SENTRY_AUTH_TOKEN
          project: foo
          org_name: risepeopleinc

```

## Configuration

| Paramater Name      | Is Required? | Description |
| ------------------- | ------------ | ----------- |
| release_name        |              | Release name to upload sourcemaps to. If not provided sentry will suggest one |
| sourcemaps_artifact | Required     | Path to uploaded artifacts |
| auth_token          |              | Sentry Auth Token, see https://docs.sentry.io/cli/configuration/ - Will try to read from $SENTRY_AUTH_TOKEN if none is provided |
| project             | Required     | Sentry Project Name |
| org_name            | Required     | Sentry organization slug |
| url_prefix          |              | Override url root, see https://docs.sentry.io/platforms/javascript/sourcemaps/#using-sentry-cli |

