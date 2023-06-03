# buildifier: disable=module-docstring
load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")
load("@cxx.rs//third-party/bazel:defs.bzl", cxx_deps = "crate_repositories")
load("@rules_proto_grpc//:repositories.bzl", "rules_proto_grpc_repos")
load("@rules_proto_grpc//python:repositories.bzl", rules_proto_grpc_python_repos = "python_repos")
load("@com_google_googleapis//:repository_rules.bzl", "switched_rules_by_language")

# buildifier: disable=function-docstring
def init_workspace0():
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
