# buildifier: disable=module-docstring
load("@rules_python//python:py_binary.bzl", _py_binary = "py_binary")
load("@rules_python//python:py_library.bzl", _py_library = "py_library")
load("@rules_python//python:py_test.bzl", _py_test = "py_test")
load("//python/proto:python_grpc_library.bzl", _python_grpc_library = "python_grpc_library")

py_library = _py_library
py_binary = _py_binary
py_test = _py_test
python_grpc_library = _python_grpc_library
