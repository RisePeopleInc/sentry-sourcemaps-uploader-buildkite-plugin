#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

@test "Uploads sourcemaps to buildkite" {
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_AUTH_TOKEN="faketoken"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_SOURCEMAPS_ARTIFACT="sourcemaps/*"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_ORG_NAME="some-org"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_PROJECT="some-project"

  stub buildkite-agent \
    "artifact download sourcemaps/* . : echo "

  stub sentry-cli \
    "releases propose-version : echo fakeversion" \
    "releases new fakeversion : echo" \
    "releases set-commits fakeversion --auto : echo" \
    "releases files fakeversion upload-sourcemaps sourcemaps/* : echo" \
    "releases finalize fakeversion : echo"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "All Done"

  unstub buildkite-agent
  unstub sentry-cli
}

@test "Doesn't crash when auth token is long and has bad data" {
  export SENTRY_AUTH_TOKEN="12345679%\$WITH0123456^79\$0123*45679@01234#56790%1234567#90"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_SOURCEMAPS_ARTIFACT="sourcemaps/*"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_ORG_NAME="some-org"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_PROJECT="some-project"

  stub buildkite-agent \
    "artifact download sourcemaps/* . : echo "

  stub sentry-cli \
    "releases propose-version : echo fakeversion" \
    "releases new fakeversion : echo" \
    "releases set-commits fakeversion --auto : echo" \
    "releases files fakeversion upload-sourcemaps sourcemaps/* : echo" \
    "releases finalize fakeversion : echo"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "All Done"

  unstub buildkite-agent
  unstub sentry-cli
}

@test "Exits early with missing token" {
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_SOURCEMAPS_ARTIFACT="sourcemaps/*"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_ORG_NAME="some-org"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_PROJECT="some-project"

  run "$PWD/hooks/command"

  assert_failure
  assert_output --partial "No auth token provided"
}
