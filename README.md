# Wrapper scaffolding-go
This wrapper is extending and/or overriding some of the functionalities of the habitat [core/scaffolding-go](https://github.com/habitat-sh/core-plans/tree/master/scaffolding-go) package.

The concept of **"Wrapper Scaffolding"** doesn't exist per se but here we are trying to define it. We are introducing a load pattern using the [`scaffolding_load()`](https://www.habitat.sh/docs/glossary/#scaffolding_load-function) function where we first load the core scaffolding that gives us its functionality and then, we override it by sourcing a library: `lib/scaffolding_overrides.sh`. This pattern allow us to test new functionalities that latter we can contribute upstream.

# Extended functionalities

By default the scaffolding will attempt to build all binaries statically and verify that they are statically built if the `DO_CHECK` environment variable is set at build time.

## Variables
The following variable have been added or modified:

#### `scaffolding_go_import_path` (override)
This variable will be overridden when the `scaffolding_go_repo_name` is specified, this will allow users to have multi-service projects.

#### `scaffolding_go_build_tags` (new)
List of build tags to pass to the go compiler. (default: empty)

#### `scaffolding_go_repo_name` (new)
The name of the repository. (default: empty)

Define this variable when you have a multi-service project that has nested Go applications. Refer to the simple go-app inside this repository for an example: https://github.com/chef/scaffolding-go/tree/master/test/go-app

#### `scaffolding_go_import_path` (new)
String defining the Go import path. (default: `$scaffolding_go_base_path/$pkg_name`)

This variable is useful for multi-binary and multi-service projects, you can use it to have a list of binaries you can build in combination with the scaffolding variable `scaffolding_go_binary_list`.

#### `scaffolding_go_binary_list` (new)
Array of binaries to build. (default: empty)

Use this variable to define the list of binaries to build, for an example look at the following **multi-binary** go application: https://github.com/chef/scaffolding-go/tree/master/test/repo/components/multi-binary

#### `scaffolding_go_no_static` (new)
Disable bulding and verifying that go binaries are statically linked. If this variable is set CGO will not be disabled, external linkers will not be passed static flags, and native go backend build tags will not be passed.

## Callbacks
The following callbacks have been added or modified:

#### `scaffolding_go_build` (override)
We are giving more flexibility and support to this callback. Now we can build multi-binary and/or multi-service projects.

#### `scaffolding_go_install` (override)
We are giving more flexibility and support to this callback. Now we can build multi-binary and/or multi-service projects.

#### `scaffolding_go_before` (override)
We are overriding this function to link the entire repository inside the studio (`/src`) to the Go workspace so that we can access multiple components, libraries and other files. (Multi-service projects)

#### `scaffolding_go_do_check_static_build` (new)
A habitat build time check to be called in the `do_check` callback. It verifies that all go binaries that are built do not dynamically load libraries. If the parent plan has define a `do_check` callback or set the `scaffolding_go_no_static` variable it will be skipped.
