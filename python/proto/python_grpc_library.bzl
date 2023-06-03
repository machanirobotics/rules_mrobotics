# buildifier: disable=module-docstring
load("@rules_proto_grpc//python:python_grpc_compile.bzl", "python_grpc_compile")
load("@rules_python//python:defs.bzl", "py_library")

def python_grpc_library(name, protos, grpcio, visibility = None):
    name_pb = name + "_pb"
    python_grpc_compile(
        name = name_pb,
        protos = protos,
    )

    py_library(
        name = name,
        srcs = [name_pb],
        deps = [
            "@com_google_protobuf//:protobuf_python",
            grpcio,
        ],
        imports = [name_pb],
        visibility = visibility,
    )
