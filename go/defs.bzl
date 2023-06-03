load("io_bazel_rules_go//go:def.bzl", _go_library = "go_library", _go_binary = "go_binary")
load("io_bazel_rules_go//proto:def.bzl", _go_proto_library = "go_proto_library")
load("@bazel_gazelle//:deps.bzl", _go_repository = "go_repository")

go_library = _go_library
go_binary = _go_binary
go_repository = go_repository
go_proto_library = _go_proto_library
go_grpc_library = _go_proto_library
