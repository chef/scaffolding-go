pkg_name=multi-binary
pkg_origin=chef
pkg_description="Multi-binary Go application to test Chef internal scaffolding-go wrapper"
pkg_maintainer="Chef Software Inc. <support@chef.io>"
pkg_version="0.1.0"
pkg_bin_dirs=(bin)
pkg_license=('Chef-MLSA')
pkg_upstream_url="https://github.com/chef/scaffolding-go/test/repo/components/multi-binary"
# @afiune This little hack will let us use the latest installed version of the
# scaffolding-go built with your origin so we can test it before releasing
pkg_scaffolding=$HAB_ORIGIN/scaffolding-go
scaffolding_go_base_path=github.com/chef
scaffolding_go_repo_name=scaffolding-go
scaffolding_go_import_path="${scaffolding_go_base_path}/$scaffolding_go_repo_name/test/repo/components/${pkg_name}"
# multi-binary projects
scaffolding_go_binary_list=(
  "${scaffolding_go_import_path}/cmd/serve-app"
  "${scaffolding_go_import_path}/cmd/cli"
)

do_prepare(){
  # Inject flags to the go compiler
  GO_LDFLAGS=" -X $scaffolding_go_import_path/config.VERSION=`date -u +%Y%m%d.%H%M%S`"
  export GO_LDFLAGS
  build_line "Setting GO_LDFLAGS=$GO_LDFLAGS"
}

