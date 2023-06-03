"""
Exports for cc
"""

load("@rules_cc//cc:defs.bzl", _cc_binary = "cc_binary", _cc_import = "cc_import", _cc_library = "cc_library")

cc_library = _cc_library
cc_binary = _cc_binary
cc_import = _cc_import
