"""
Python proto toolchain
"""

load("@rules_python//python:defs.bzl", "PyInfo")

def _python_proto_toolchain_impl(ctx):
    return platform_common.ToolchainInfo(
        grpcio = ctx.attr.grpcio,
    )

python_proto_toolchain = rule(
    implementation = _python_proto_toolchain_impl,
    attrs = {
        "grpcio": attr.label(mandatory = True, doc = "grpcio python library", providers = [PyInfo]),
    },
)
