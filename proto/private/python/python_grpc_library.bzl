"""
Python grpc library rule
"""

load("@rules_proto_grpc//python:python_grpc_compile.bzl", "python_grpc_compile")
load("@rules_python//python:defs.bzl", "py_library")

def _get_python_proto_deps_impl(ctx):
    """
    Simple rule that gets the dependencies defined by python_proto_toolchain
    """

    proto_toolchain = ctx.toolchains[Label("//proto/python:toolchain_type")]
    grpcio = proto_toolchain.grpcio

    return [
        grpcio[PyInfo],
    ]

_get_python_proto_deps = rule(
    implementation = _get_python_proto_deps_impl,
    toolchains = [
        str(Label("//proto/python:toolchain_type")),
    ],
)

def python_grpc_library(name, protos, visibility = None):
    """
    Python gRPC library macro

    Args:
        name: name of the final py_library rule that this macro generates
        protos: protos to compile
        visibility: visibility of the py_library rule that this macro generates
    """
    name_pb = name + "_pb"
    name_deps = name + "_deps"

    python_grpc_compile(
        name = name_pb,
        protos = protos,
    )

    _get_python_proto_deps(
        name = name_deps,
    )

    py_library(
        name = name,
        srcs = [name_pb],
        deps = [
            "@com_google_protobuf//:protobuf_python",
            name_deps,
        ],
        imports = [name_pb],
        visibility = visibility,
    )
