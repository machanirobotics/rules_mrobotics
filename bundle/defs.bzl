# buildifier: disable=module-docstring
load("//bundle/private/app:app.bzl", _bootstrapped_binary = "bootstrapped_binary")
load("//bundle/private/pkgy:pkgfy.bzl", _pkgfy = "pkgfy")
load("//bundle/private:ld_env.bzl", _ld_env = "ld_env")

bootstrapped_binary = _bootstrapped_binary
pkgfy = _pkgfy
ld_env = _ld_env
