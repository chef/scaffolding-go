pkg_name=scaffolding-go
pkg_origin=chef
pkg_description="Scaffolding for Go Applications internally at Chef Software Inc."
pkg_maintainer="Chef Software Inc. <support@chef.io>"
pkg_version="0.1.0"
pkg_license=('Chef-MLSA')
pkg_source=nosuchfile.tar.gz
pkg_upstream_url="https://github.com/chef/scaffolding-go"
pkg_deps=(
  core/scaffolding-go
  core/grep
)

do_build() {
  return 0
}

do_verify() {
  return 0
}

do_unpack() {
  return 0
}

do_download() {
  return 0
}

# Install scaffolding libraries from the plan into the package.
do_install() {
  install -D -m 0644 "$PLAN_CONTEXT/../lib/scaffolding.sh" "$pkg_prefix/lib/scaffolding.sh"
  install -D -m 0644 "$PLAN_CONTEXT/../lib/scaffolding_overrides.sh" "$pkg_prefix/lib/scaffolding_overrides.sh"

  # libs from core/scaffolding-go
  install -D -m 0644 "$(pkg_path_for core/scaffolding-go)/lib/go_module.sh" "$pkg_prefix/lib/go_module.sh"
  install -D -m 0644 "$(pkg_path_for core/scaffolding-go)/lib/gopath_mode.sh" "$pkg_prefix/lib/gopath_mode.sh"
}
