# buildifier: disable=module-docstring
load("@rules_rust//rust:defs.bzl", _rust_binary = "rust_binary", _rust_library = "rust_library")
load("//rust/ffi:cxx_bridge.bzl", "rust_cxx_bridge")

rust_library = _rust_library
rust_binary = _rust_binary
rust_cc_bridge = rust_cxx_bridge
