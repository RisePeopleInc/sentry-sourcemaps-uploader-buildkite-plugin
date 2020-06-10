# Buildkite Plugin for Uploading sourcemaps to Sentry as private sourcemaps

This plugin is used to upload sourcemaps to Sentry as private sourcemaps.

An example of how to use this plugin is:

```
  - label: Upload Private SourceMaps to Sentry
    plugins:
      - ssh://git@github.com:RisePeopleInc/sentry-sourcemaps-uploader-buildkite-plugin.git#master:
          release_name: $BUILDKITE_COMMIT
          sourcemaps_artifact: sourcemaps/*
          auth_token: $SENTRY_AUTH_TOKEN
          project: foo
          org_name: risepeopleinc
```