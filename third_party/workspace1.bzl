# buildifier: disable=module-docstring
load("@rules_mrobotics_crate_index//:defs.bzl", "crate_repositories")
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")

def init_workspace1():
    # rust_deps
    crate_repositories()

    # rules proto
    rules_proto_dependencies()
    rules_proto_toolchains()

    # required by rules proto grpc python
    grpc_deps()
