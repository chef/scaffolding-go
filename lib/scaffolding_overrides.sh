#!/bin/bash
# shellcheck shell=bash

# This is the place where we can override any functionality of the core scaffolding. (functions, variables, etc.)

# Override do_default_before
do_default_before() {
  # Do something before loading the core scaffolding_go_before
  build_line "We should see this test message! :)"

  scaffolding_go_before
}
