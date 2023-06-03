"""
Exports for python
"""

load("@rules_python//python:py_binary.bzl", _py_binary = "py_binary")
load("@rules_python//python:py_library.bzl", _py_library = "py_library")
load("@rules_python//python:py_test.bzl", _py_test = "py_test")

py_library = _py_library
py_binary = _py_binary
py_test = _py_test
