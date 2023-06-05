"""
Python proto toolchain
"""

def _rust_proto_toolchain_impl(ctx):
    return platform_common.ToolchainInfo(
        edition = ctx.attr.edition,
        deps = ctx.attr.deps,
    )

rust_proto_toolchain = rule(
    implementation = _rust_proto_toolchain_impl,
    attrs = {
        "edition": attr.string(mandatory = True, doc = "rust edition"),
        "deps": attr.label_list(mandatory = True, doc = "the dependencies to compile the grpc library. typically includes tonic, prost and optionally, prost_types"),
    },
)
