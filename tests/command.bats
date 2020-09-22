#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

@test "Uploads sourcemaps to buildkite" {
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_AUTH_TOKEN="faketoken"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_SOURCEMAPS_ARTIFACT="sourcemaps/*"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_ORG_NAME="some-org"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_PROJECT="some-project"

  stub mkdir \
    "-p downloaded_artifacts : echo Made Directory"

  stub buildkite-agent \
    "artifact download sourcemaps/* downloaded_artifacts : echo Downloaded Artifacts"

  stub sentry-cli \
    "releases propose-version : echo fakeversion" \
    "releases new fakeversion : echo new fake version" \
    "releases set-commits fakeversion --auto : echo set-commits" \
    "releases files fakeversion upload-sourcemaps downloaded_artifacts/ --strip-prefix=downloaded_artifacts/ '' : echo Uploaded Files" \
    "releases finalize fakeversion : echo"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "Downloaded Artifacts"
  assert_output --partial "Uploaded Files"
  assert_output --partial "All Done"

  unstub mkdir
  unstub buildkite-agent
  unstub sentry-cli
}

@test "Uploads sourcemaps to buildkite - Supports extra strip prefix" {
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_AUTH_TOKEN="faketoken"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_SOURCEMAPS_ARTIFACT="sourcemaps/*"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_ORG_NAME="some-org"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_PROJECT="some-project"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_STRIP_PREFIX="strippie/"

  stub mkdir \
    "-p downloaded_artifacts : echo Made Directory"

  stub buildkite-agent \
    "artifact download sourcemaps/* downloaded_artifacts : echo Downloaded Artifacts"

  stub sentry-cli \
    "releases propose-version : echo fakeversion" \
    "releases new fakeversion : echo new fake version" \
    "releases set-commits fakeversion --auto : echo set-commits" \
    "releases files fakeversion upload-sourcemaps downloaded_artifacts/ --strip-prefix=downloaded_artifacts/strippie/ '' : echo Uploaded Files" \
    "releases finalize fakeversion : echo"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "Downloaded Artifacts"
  assert_output --partial "Uploaded Files"
  assert_output --partial "All Done"

  unstub mkdir
  unstub buildkite-agent
  unstub sentry-cli
}

@test "Uploads sourcemaps to buildkite - Supports upload subpath" {
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_AUTH_TOKEN="faketoken"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_SOURCEMAPS_ARTIFACT="sourcemaps/*"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_ORG_NAME="some-org"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_PROJECT="some-project"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_STRIP_PREFIX="strippie/"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_UPLOAD_SUBDIRECTORY="upload_subpath"


  stub mkdir \
    "-p downloaded_artifacts : echo Made Directory"

  stub buildkite-agent \
    "artifact download sourcemaps/* downloaded_artifacts : echo Downloaded Artifacts"

  stub sentry-cli \
    "releases propose-version : echo fakeversion" \
    "releases new fakeversion : echo new fake version" \
    "releases set-commits fakeversion --auto : echo set-commits" \
    "releases files fakeversion upload-sourcemaps downloaded_artifacts/upload_subpath --strip-prefix=downloaded_artifacts/strippie/ '' : echo Uploaded Files" \
    "releases finalize fakeversion : echo"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "Downloaded Artifacts"
  assert_output --partial "Uploaded Files"
  assert_output --partial "All Done"

  unstub mkdir
  unstub buildkite-agent
  unstub sentry-cli
}

@test "Doesn't crash when auth token is long and has bad data" {
  export SENTRY_AUTH_TOKEN="12345679%\$WITH0123456^79\$0123*45679@01234#56790%1234567#90"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_SOURCEMAPS_ARTIFACT="sourcemaps/*"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_ORG_NAME="some-org"
  export BUILDKITE_PLUGIN_SENTRY_SOURCEMAPS_UPLOADER_PROJECT="some-project"

  stub mkdir \
    "-p downloaded_artifacts : echo Made Directory"

  stub buildkite-agent \
    "artifact download sourcemaps/* downloaded_artifacts : echo Downloaded Artifacts"

  stub sentry-cli \
    "releases propose-version : echo fakeversion" \
    "releases new fakeversion : echo new fake version" \
    "releases set-commits fakeversion --auto : echo set-commits" \
    "releases files fakeversion upload-sourcemaps downloaded_artifacts/ --strip-prefix=downloaded_artifacts/ '' : echo Uploaded Files" \
    "releases finalize fakeversion : echo"

  run "$PWD/hooks/command"

  assert_success
  assert_output --partial "Downloaded Artifacts"
  assert_output --partial "Uploaded Files"
  assert_output --partial "All Done"

  unstub mkdir
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
