#!/bin/bash
#
# Wrapping the core Go scaffolding (Base)
#
# The concept of 'Wrapper Scaffolding' doens't exist perse but here we are trying to
# define how should it look like.
#
# This function is loading the parent core go scaffolding first, all callbacks, variables
# and customizations. Then it will load this new wrapper scaffolding that will override
# some of the functionality of the parent.
#
# This callback executes immediately after the scaffolding is loaded, to do something
# prior this function use the 'default_begin' phase.
scaffolding_load() {
  # Load the base scaffolding that we want to wrap
  # TODO @afiune Find a way to define a 'pkg_abc' variable in plan.sh (pkg_scaffolding_base?)
  local lib
  lib="$(pkg_path_for "core/scaffolding-go")/lib/scaffolding.sh"
  build_line "Loading Base Scaffolding $lib"
  # shellcheck disable=SC1090
  if ! source "$lib"; then
    exit_with "Failed to load Base Scaffolding from $lib" 17
  fi

  if [[ "$(type -t scaffolding_load)" == "function" ]]; then
    scaffolding_load
  fi

  # Load the wrapper scaffolding
  # This is the place where we override any functionality of the base scaffolding
  lib="$(pkg_path_for "$pkg_scaffolding")/lib/scaffolding_overrides.sh"
  build_line "Loading Wrapper Scaffolding $lib"
  # shellcheck disable=SC1090
  if ! source "$lib"; then
    exit_with "Failed to load Wrapper Scaffolding from $lib" 17
  fi

  # Load this file again to override the 'scaffolding_load' function
  lib="$(pkg_path_for "$pkg_scaffolding")/lib/scaffolding.sh"
  # shellcheck disable=SC1090
  if ! source "$lib"; then
    exit_with "Failed to load Wrapper Scaffolding from $lib" 17
  fi
}

#
# NO MORE FUNCTIONS ARE NEEDED HERE. GO TO => 'lib/scaffolding_overrides.sh'
#
