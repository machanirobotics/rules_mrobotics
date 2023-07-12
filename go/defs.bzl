"""
Exports for go
"""

load("@io_bazel_rules_go//go:def.bzl", _go_binary = "go_binary", _go_library = "go_library", _go_test = "go_test")
load("@bazel_gazelle//:deps.bzl", _go_repository = "go_repository")
load("@bazel_gazelle//:def.bzl", _gazelle = "gazelle")


go_library = _go_library
go_binary = _go_binary
go_test = _go_test
go_repository = _go_repository
gazelle = _gazelle