# buildifier: disable=module-docstring
# rust:
load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies", "rust_register_toolchains")
load("@rules_rust//tools/rust_analyzer:deps.bzl", "rust_analyzer_dependencies")
load("@rules_rust//crate_universe:repositories.bzl", "crate_universe_dependencies")

# go:
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

# gazelle:
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

# python:
load("@rules_python//python:repositories.bzl", "py_repositories", "python_register_toolchains")

# rules proto grpc
load("@rules_proto_grpc//:repositories.bzl", "rules_proto_grpc_toolchains")

# google apis -reflink1
# load("@googleapis//:repository_rules.bzl", "switched_rules_by_language")


# buildifier: disable=function-docstring
# buildifier: disable=unnamed-macro
def load_toolchains():
    # cc
    native.register_toolchains(
        "//cc/toolchain/clang:x86_64_local_cc_toolchain",
        "//cc/toolchain/clang:aarch64_local_cc_toolchain",
        "//cc/toolchain/clang:linux_aarch64_cross_cc_toolchain",
    )

    # rust:
    rules_rust_dependencies()
    rust_register_toolchains(
        edition = "2021",
        extra_target_triples = [
            "aarch64-unknown-linux-gnu",
        ],
        versions = [
            "1.68.1",
        ],
    )

    rust_analyzer_dependencies()
    crate_universe_dependencies()

    # go:
    go_rules_dependencies()
    go_register_toolchains(version = "1.20.5")

    gazelle_dependencies(go_repository_default_config = "//:WORKSPACE.bazel")

    # - reflink1
    # switched_rules_by_language(
    #     name = "com_google_googleapis_imports",
    # )

    # python:
    py_repositories()
    python_register_toolchains(
        name = "python",
        python_version = "3.10",
    )

    # rules proto grpc
    rules_proto_grpc_toolchains()
