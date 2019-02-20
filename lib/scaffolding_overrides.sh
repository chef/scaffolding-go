#!/bin/bash
#
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
  # We se this command since it will build and install the binaries
  # automatically into the GOBIN directory
  local go_cmd="go install"

  # Inject Go ldflags
  if [[ $GO_LDFLAGS ]]; then
    go_cmd="$go_cmd --ldflags '${GO_LDFLAGS}'"
  fi

  # Inject Go build tags
  if [[ $scaffolding_go_build_tags ]]; then
    go_cmd="$go_cmd --tags '${scaffolding_go_build_tags[*]}'"
  fi

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
