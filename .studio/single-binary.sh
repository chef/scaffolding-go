#!/bin/bash

# Helper methods for the test/repo/components/single-binary app

# build_and_test_single_binary_app builds and tests the single-binary app
function build_and_test_single_binary_app() {
  local rc

  # Build a single-binary Go app
  echo ""
  build_single_binary_app
  rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi

  # Test that the app was built and installed and can be run
  #
  # Output should look like:
  # => libs: complex stuff happening.
  #    single-binary: Hola, todo bien!
  echo ""
  yellow "* Running single-binary Go application. (single-binary)\\n"
  single-binary
  rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi

  # TODO @afiune How to test the change of tags?
}

# build_single_binary_app builds a single-binary Go application to test the latest installed scaffolding-go pkg
function build_single_binary_app() {
  local pkg_path
  pkg_path=$(verify_or_install_scaffolding_go)
  yellow "* Building single-binary Go application using latest installed $HAB_ORIGIN/scaffolding-go package."
  echo -e "$(green "  PKG_PATH:") $pkg_path\\n"
  build /src/test/repo/components/single-binary
  local rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi

  # Installing latest single-binary Go application
  echo ""
  install_latest_single_binary_app
}

# install_latest_single_binary_app install the latest single-binary Go application built
function install_latest_single_binary_app() {
  local last_build
  last_build=$(find /src/results -name "${HAB_ORIGIN}-single-binary-*" | sort | tail -1)
  if [[ "$last_build" == "" ]]; then
    echo -e "$(red "ERROR:") No 'single-binary' builds found. Build one with: 'build_single_binary_app'"
  else
    hab pkg install -b -f "$last_build"
  fi
}
