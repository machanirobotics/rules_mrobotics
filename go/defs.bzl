# buildifier: disable=module-docstring
load("@io_bazel_rules_go//go:def.bzl", _go_binary = "go_binary", _go_library = "go_library")
load("@bazel_gazelle//:deps.bzl", _go_repository = "go_repository")

go_library = _go_library
go_binary = _go_binary
go_repository = _go_repository
