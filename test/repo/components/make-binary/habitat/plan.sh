pkg_name=make-binary
pkg_origin=chef
pkg_description="Single-binary Go application to test Chef internal scaffolding-go wrapper"
pkg_maintainer="Chef Software Inc. <support@chef.io>"
pkg_version="0.1.0"
pkg_bin_dirs=(bin)
pkg_license=('Chef-MLSA')
pkg_upstream_url="https://github.com/chef/scaffolding-go/test/repo/components/single-binary"
# @afiune This little hack will let us use the latest installed version of the
# scaffolding-go built with your origin so we can test it before releasing
pkg_scaffolding=$HAB_ORIGIN/scaffolding-go
scaffolding_go_base_path=github.com/chef
scaffolding_go_repo_name=scaffolding-go
scaffolding_go_import_path="${scaffolding_go_base_path}/$scaffolding_go_repo_name/test/repo/components/${pkg_name}"
