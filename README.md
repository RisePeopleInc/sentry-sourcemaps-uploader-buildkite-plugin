# Buildkite Plugin for Uploading sourcemaps to Sentry as private sourcemaps

This plugin is used to upload sourcemaps to Sentry as private sourcemaps.

An example of how to use this plugin is:

To generate a sentry auth token, see https://docs.sentry.io/cli/configuration/

```
  - label: Upload Private SourceMaps to Sentry
    plugins:
      - RisePeopleInc/sentry-sourcemaps-uploader#master:
          release_name: $BUILDKITE_COMMIT
          sourcemaps_artifact: sourcemaps/*
          auth_token: $SENTRY_AUTH_TOKEN
          project: foo
          org_name: risepeopleinc
```

## Parameters

| Paramater Name      | Is Required? | Description |
| ------------------- | ------------ | ----------- |
| release_name        |              | Release name to upload sourcemaps to. If not provided sentry will suggest one |
| sourcemaps_artifact | Required     | Path to uploaded artifacts |
| auth_token          | Required     | Sentry Auth Token, see https://docs.sentry.io/cli/configuration/ |
| project             | Required     | Sentry Project Name |
| org_name            | Required     | Sentry organization slug |
| url_prefix          |              | Override url root, see https://docs.sentry.io/platforms/javascript/sourcemaps/#using-sentry-cli |

