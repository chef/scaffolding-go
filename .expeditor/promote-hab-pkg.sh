#!/bin/bash

set -eou pipefail

# @afiune Can we source the 'habitat/plan.sh' to have this info?
pkg_origin="chef"
channel="unstable"
pkg_name="scaffolding-go"

# Get the release and version
results=$(curl --silent https://willem.habitat.sh/v1/depot/channels/${pkg_origin}/${channel}/pkgs/${pkg_name}/latest | jq '.ident')
pkg_version=$(echo "$results" | jq -r .version)
pkg_release=$(echo "$results" | jq -r .release)

hab pkg promote "${pkg_origin}/${pkg_name}/${pkg_version}/${pkg_release}" stable
