#!/bin/bash

# Helper methods for the test/go-app simple app

# build_and_test_simple_go_app builds and tests the a simple Go app
function build_and_test_simple_go_app() {
  local rc

  # Build a simple Go app
  echo ""
  build_simple_go_app
  rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi

  # Test that the app was built and installed and can be run
  #
  # Output should look like:
  # => go-app: Hello Chef Friends! :) v.20180912.161904
  echo ""
  yellow "* Running simple Go application. (go-app)\\n"
  go-app
  rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi
}

# build_simple_go_app builds a simple Go application to test the latest installed scaffolding-go pkg
function build_simple_go_app() {
  local pkg_path
  pkg_path=$(verify_or_install_scaffolding_go)
  yellow "* Building simple Go application using latest installed $HAB_ORIGIN/scaffolding-go package."
  echo -e "$(green "  PKG_PATH:") $pkg_path\\n"
  build /src/test/go-app
  local rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi

  # Installing latest go-app
  echo ""
  install_latest_simple_go_app
}

# install_latest_simple_go_app install the latest go-app built
function install_latest_simple_go_app() {
  local last_build
  last_build=$(ls -1t "results/${HAB_ORIGIN}-go-app-"* | head -1)
  if [[ "$last_build" == "" ]]; then
    echo -e "$(red "ERROR:") No 'go-app' builds found. Build one with: 'build_simple_go_app'"
  else
    hab pkg install -b -f "$last_build"
  fi
}
