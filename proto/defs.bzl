"""
Exports for proto
"""

load("@rules_proto//proto:defs.bzl", _proto_library = "proto_library")
load("@io_bazel_rules_go//proto:def.bzl", _go_proto_library = "go_proto_library")
load("//proto/private/rust:tonic.bzl", _rust_grpc_library = "tonic_grpc_library")
load("//proto/private/python:python_grpc_library.bzl", _python_grpc_library = "python_grpc_library")

proto_library = _proto_library

go_proto_library = _go_proto_library
go_grpc_library = _go_proto_library

rust_grpc_library = _rust_grpc_library

python_grpc_library = _python_grpc_library
