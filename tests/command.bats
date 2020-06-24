#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

@test "Uploads sourcemaps to buildkite" {
  export BUILDKITE_PLUGIN_FILE_COUNTER_PATTERN="*.bats"

  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_AUTH_TOKEN="faketoken"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_SOURCEMAPS_ARTIFACT="sourcemaps"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_ORG_NAME="some-org"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_PROJECT="some-project"

  stub buildkite-agent \
    "artifact download sourcemaps . : echo "

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
