"""
Rust ffi rule to generating c++ bindings
"""

load("@bazel_skylib//rules:run_binary.bzl", "run_binary")
load("@rules_cc//cc:defs.bzl", "cc_library")

def rust_cxx_bridge(name, src, cc_deps = [], visibility = []):
    """
    Runs cxx brige to generated bindings.

    Args:
        name: name of the macro
        src: rust source file containing the bridge
        cc_deps: additional c++ dependencies for the generated c++ files
        visibility: visibility
    """

    source = src + ".cpp"
    header = src + ".hpp"

    run_binary(
        name = "%s.generated" % name,
        srcs = [src],
        outs = [
            source,
            header,
        ],
        args = [
            "$(location %s)" % src,
            "-o",
            "$(location %s)" % header,
            "-o",
            "$(location %s)" % source,
        ],
        tool = "@cxx.rs//:codegen",
    )

    cc_library(
        name = name,
        srcs = [
            source,
        ],
        deps = cc_deps + [
            ":%s.include" % name,
        ],
        visibility = visibility,
    )

    cc_library(
        name = "%s.include" % name,
        hdrs = [
            header,
        ],
        visibility = visibility,
    )
