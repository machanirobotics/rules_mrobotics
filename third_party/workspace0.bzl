# buildifier: disable=module-docstring
load("@rules_rust//crate_universe:defs.bzl", "crates_repository", "render_config")
load("//third_party/cargo:deps.bzl", "cargo_info")
load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")
load("@cxx.rs//third-party/bazel:defs.bzl", cxx_deps = "crate_repositories")
load("@rules_proto_grpc//:repositories.bzl", "rules_proto_grpc_repos")
load("@rules_proto_grpc//python:repositories.bzl", rules_proto_grpc_python_repos = "python_repos")
load("@com_google_googleapis//:repository_rules.bzl", "switched_rules_by_language")

# buildifier: disable=function-docstring
def init_workspace0():
    # cargo
    crates_repository(
        name = "rules_mrobotics_crate_index",
        cargo_lockfile = "//third_party/cargo:Cargo.lock",
        lockfile = "//third_party/cargo:Cargo.Bazel.lock",
        generate_binaries = True,
        packages = cargo_info.packages,
        render_config = render_config(
            default_package_name = "",
        ),
    )

    # protobuf
    protobuf_deps()

    # cxxbridge-cmd
    cxx_deps()

    # rules proto grpc
    rules_proto_grpc_repos()
    rules_proto_grpc_python_repos()

    # googleapis proto
    switched_rules_by_language(
        name = "com_google_googleapis_imports",
        go = True,
        grpc = True,
        python = True,
    )
