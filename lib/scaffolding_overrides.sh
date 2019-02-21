#!/bin/bash

#shellcheck disable=SC2034
#shellcheck disable=SC2154

# This is the place where we can override any functionality of the core scaffolding. (functions, variables, etc.)

#
# Scaffolding Variables
#

# Override scaffolding_go_pkg_path
#
# The '$scaffolding_go_repo_name' variable will allow users to have multi-service projects, by
# specifying the repository name of the project the '$scaffolding_go_pkg_path' will get overwritten
# as follows:
if [[ $scaffolding_go_repo_name ]]; then
  export scaffolding_go_pkg_path="$scaffolding_go_workspace_src/$scaffolding_go_base_path/$scaffolding_go_repo_name"
fi

# Export GOBIN and add it to the PATH environment variable
export GOBIN="$scaffolding_go_gopath/bin"
export PATH="$PATH:$GOBIN"

# Sets the default value when '$scaffolding_go_import_path' is not set
#
# This will be useful for multi-binary and/or multi-service projects, you can have a combination
# of binaries you can build in conjuction with the scaffolding variable '$scaffolding_go_binary_list'
if [[ ! $scaffolding_go_import_path ]]; then
  export scaffolding_go_import_path=$scaffolding_go_base_path/$pkg_name
fi


#
# Scaffolding Callback Functions
#

# Override scaffolding_go_build
#
# We are giving more flexibility and support to this callback, now we can
# have projects that are multi-binary and/or multi-service
# TODO @afiune Support Makefile's
scaffolding_go_build() {
  local go_cmd="go install"

  # Default to a static build unless the user plan has defined the
  # scaffolding_go_no_static variable.
  if ! [[ $scaffolding_go_no_static ]]; then
    # Go doesn't currently have an "easy" way to enforce static builds. Until the
    # proposed `-static` flag is added to go-build/go-install we'll need to add
    # the proper environment variables, ldflags and tags.
    build_line "Configuring static build"

    # We assume no CGO here. While we could probably go to some length to leave
    # CGO enabled and use musl, it's probably best for projects that would need
    # must to override this hook and build it as necessary.
    go_cmd="CGO_ENABLED=0 $go_cmd"

    GO_LDFLAGS="$GO_LDFLAGS -extldflags \"-fno-PIC -static\""

    if ! [[ $scaffolding_go_build_tags ]]; then
      declare -a scaffolding_go_build_tags=()
    fi
    scaffolding_go_build_tags+=('osusergo netgo static_build')
    unique_tags=$(
      for i in "${scaffolding_go_build_tags[@]}"; do
        echo "$i";
      done | uniq
    )
    scaffolding_go_build_tags=(unique_tags)
  fi

  # Inject Go ldflags
  if [[ $GO_LDFLAGS ]]; then
    go_cmd="$go_cmd --ldflags '${GO_LDFLAGS}'"
  fi

  # Inject Go build tags
  if [[ ${scaffolding_go_build_tags[*]} ]]; then
    go_cmd="$go_cmd --tags '${scaffolding_go_build_tags[*]}'"
  fi

  build_line "Using Build Command: $go_cmd"

  pushd "$scaffolding_go_pkg_path" >/dev/null || return 1
    if [[ $scaffolding_go_binary_list ]]; then
      for binary in "${scaffolding_go_binary_list[@]}"; do
        eval "$go_cmd $binary"
      done
    else
      eval "$go_cmd $scaffolding_go_import_path"
    fi
  popd >/dev/null || return 1
}

# Override scaffolding_go_before
scaffolding_go_before() {
  # Initialize the Go Workspace package path if we are tryng to build the
  # package from local /src, that is when there is no $pkg_source set.
  #
  # @afiune we are overriding this function since we must link the entire
  # repository '/src' to the Go workspace to access other files/components
  # or files. (Multi-service projects)
  if [ ! "$pkg_source" ] && [ ! -e "$scaffolding_go_pkg_path" ]; then
    mkdir -p "$scaffolding_go_workspace_src/$scaffolding_go_base_path"
    ln -sf /src "$scaffolding_go_pkg_path"
  fi
}

# Override scaffolding_go_install
#
# Enable multi-binary and/or multi-service projects
scaffolding_go_install() {
  if [[ $scaffolding_go_binary_list ]]; then
    for binary in "${scaffolding_go_binary_list[@]}"; do
      local b
      b=$(basename "$binary")
      cp -r "${GOBIN}/$b" "${pkg_prefix}/bin/"
    done
  else
    cp -r "${GOBIN}/$pkg_name" "${pkg_prefix}/bin/"
  fi
}


# Set a default do_check if it does not exist
if ! type -t do_check; then
  do_check() {
    scaffolding_go_do_check_static_build
  }
fi

# Ensure that the go binaries are static
scaffolding_go_do_check_static_build() {
  if ! [[ $scaffolding_go_no_static ]]; then
    check_static_binary() {
      build_line "Checking for dynamic links in $1"
      if ! ldd "$1" | grep "not a dynamic executable"; then
          exit_with "${binary} is not a static executable" 1
      fi
    }

    if [[ $scaffolding_go_binary_list ]]; then
      for binary in "${scaffolding_go_binary_list[@]}"; do
        base=$(basename "$binary")
        check_static_binary "${GOBIN}/${base}"
      done
    else
      check_static_binary "${GOBIN}/$pkg_name"
    fi
  fi

  return 0
}
