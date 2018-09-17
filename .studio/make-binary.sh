#!/bin/bash

# Helper methods for the test/repo/components/make-binary app

# build_and_test_make_binary_app builds and tests the make-binary app
function build_and_test_make_binary_app() {
  local rc

  # Build a make-binary Go app
  echo ""
  build_make_binary_app
  rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi

  # Test that the app was built and installed and can be run
  #
  # Output should look like:
  # => make-binary: Built with a custom Makefile.
  echo ""
  yellow "* Running make-binary Go application. (make-binary)\\n"
  make-binary
  rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi
}

# build_make_binary_app builds a make-binary Go application to test the latest installed scaffolding-go pkg
function build_make_binary_app() {
  local pkg_path
  pkg_path=$(verify_or_install_scaffolding_go)
  yellow "* Building make-binary Go application using latest installed $HAB_ORIGIN/scaffolding-go package."
  echo -e "$(green "  PKG_PATH:") $pkg_path\\n"
  build /src/test/repo/components/make-binary
  local rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi

  # Installing latest make-binary
  echo ""
  install_latest_make_binary_app
}

# install_latest_make_binary_app install the latest make-binary built
function install_latest_make_binary_app() {
  local last_build
  last_build=$(ls -1t "results/${HAB_ORIGIN}-make-binary-"* | head -1)
  if [[ "$last_build" == "" ]]; then
    echo -e "$(red "ERROR:") No 'make-binary' builds found. Build one with: 'build_make_binary_app'"
  else
    hab pkg install -b -f "$last_build"
  fi
}
