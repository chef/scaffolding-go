#!/bin/bash

# Helper methods for the test/repo/components/multi-binary app

# build_and_test_multi_binary_app builds and tests the multi-binary app
function build_and_test_multi_binary_app() {
  local rc
  local response

  # Build a multi-binary Go app
  echo ""
  build_multi_binary_app
  rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi

  # Test that the app was built and installed and can be run
  #
  # ------ Binary 1 (server)
  # Output should look like:
  # => multi-binary: Starting app listening on ':9090'. (v.20180913.111142)
  #
  # When requests come in, the response should look like:
  # => {"req_num":1,"status":"processed"}
  echo ""
  verify_or_start_supervisor
  svc_running "$HAB_ORIGIN/multi-binary"
  rc=$?
  if [[ $rc == 0 ]]; then
    yellow "* The multi-binary Go application is already running. (serve-app)"
    green "* To see the logs of the service run 'sup-log'.\\n"
  else
    start_multi_binary_serve_app
  fi

  response=$(curl_multi_binary_serve_app)
  rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi
  echo "$response" | jq .

  # ------ Binary 2 (cli)
  # Output should look like:
  # => multi-binary: Running app through the cli. (v.20180912.165542)
  #    libs: complex stuff happening.
  echo ""
  yellow "* Running multi-binary Go application. (cli)\\n"
  cli
  rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi
}

# start_multi_binary_serve_app starts the multi-binary go application through hab-svc commands
# run 'sup-log' to see the logs
function start_multi_binary_serve_app() {
  local pkg_ident
  pkg_ident="$HAB_ORIGIN/multi-binary"
  yellow "* Starting multi-binary Go application. (serve-app)\\n"
  hab svc load "$pkg_ident" -s at-once
  hab start "$pkg_ident"
  wait_or_fail_for_svc_to_load "$pkg_ident" 30
}

# curl_multi_binary_serve_app sends a curl request to the running multi-binary go application
function curl_multi_binary_serve_app() {
  local response=""
  local rc=0
  local address="localhost:9090"
  install_if_missing core/curl curl
  install_if_missing core/jq-static jq
  response=$(curl $address 2>/dev/null)
  rc=$?
  if [[ $rc != 0 ]]; then
    echo "Unable to curl serve app. ($address)"
    return $rc
  fi
  echo "$response"
}

# build_multi_binary_app builds a multi-binary Go application to test the latest installed scaffolding-go pkg
function build_multi_binary_app() {
  local pkg_path
  pkg_path=$(verify_or_install_scaffolding_go)
  yellow "* Building multi-binary Go application using latest installed $HAB_ORIGIN/scaffolding-go package."
  echo -e "$(green "  PKG_PATH:") $pkg_path\\n"
  build /src/test/repo/components/multi-binary
  local rc=$?
  if [[ $rc != 0 ]]; then
    return $rc;
  fi

  # Installing latest multi-binary Go application
  echo ""
  install_latest_multi_binary_app
}

# install_latest_multi_binary_app install the latest multi-binary Go application built
function install_latest_multi_binary_app() {
  local last_build
  last_build=$(ls -1t "results/${HAB_ORIGIN}-multi-binary-"* | head -1)
  if [[ "$last_build" == "" ]]; then
    echo -e "$(red "ERROR:") No 'multi-binary' builds found. Build one with: 'build_multi_binary_app'"
  else
    hab pkg install -b -f "$last_build"
  fi
}
