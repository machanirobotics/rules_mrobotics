# buildifier: disable=module-docstring
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# buildifier: disable=function-docstring
def load_repositories():
    http_archive(
        name = "com_google_protobuf",
        sha256 = "f3f9ce6dc288f2f939bdc9d277ebdfbc8dbcd51741071f93da70e0e62919f57f",
        urls = [
            "https://github.com/protocolbuffers/protobuf/archive/v21.10.tar.gz",  # match version with rules_proto_grpc/respositories.bzl
        ],
        patches = [
            "@rules_mrobotics//third_party/patches:com_google_protobuf.patch",
        ],
        strip_prefix = "protobuf-21.10",
    )

    http_archive(
        name = "com_google_absl",
        urls = [
            "https://github.com/abseil/abseil-cpp/archive/20230125.3.tar.gz",
        ],
        strip_prefix = "abseil-cpp-20230125.3",
    )

    http_archive(
        name = "bazel_skylib",
        sha256 = "b8a1527901774180afc798aeb28c4634bdccf19c4d98e7bdd1ce79d1fe9aaad7",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
        ],
    )

    http_archive(
        name = "rules_rust",
        sha256 = "50272c39f20a3a3507cb56dcb5c3b348bda697a7d868708449e2fa6fb893444c",
        urls = ["https://github.com/bazelbuild/rules_rust/releases/download/0.22.0/rules_rust-v0.22.0.tar.gz"],
        patches = [
            "@rules_mrobotics//third_party/patches:rules_rust.patch",
        ],
    )

    http_archive(
        name = "rules_python",
        sha256 = "863ba0fa944319f7e3d695711427d9ad80ba92c6edd0b7c7443b84e904689539",
        strip_prefix = "rules_python-0.22.0",
        url = "https://github.com/bazelbuild/rules_python/releases/download/0.22.0/rules_python-0.22.0.tar.gz",
    )

    http_archive(
        name = "io_bazel_rules_go",
        sha256 = "6dc2da7ab4cf5d7bfc7c949776b1b7c733f05e56edc4bcd9022bb249d2e2a996",
        urls = [
            "https://github.com/bazelbuild/rules_go/releases/download/v0.39.1/rules_go-v0.39.1.zip",
        ],
    )

    http_archive(
        name = "rules_proto_grpc",
        sha256 = "928e4205f701b7798ce32f3d2171c1918b363e9a600390a25c876f075f1efc0a",
        strip_prefix = "rules_proto_grpc-4.4.0",
        urls = ["https://github.com/rules-proto-grpc/rules_proto_grpc/releases/download/4.4.0/rules_proto_grpc-4.4.0.tar.gz"],
    )

    http_archive(
        name = "bazel_gazelle",
        sha256 = "727f3e4edd96ea20c29e8c2ca9e8d2af724d8c7778e7923a854b2c80952bc405",
        urls = [
            "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.30.0/bazel-gazelle-v0.30.0.tar.gz",
        ],
    )

    # for cxxbridge-cmd
    http_archive(
        name = "cxx.rs",
        strip_prefix = "cxx-1.0.94",
        sha256 = "0c8d5c2fad6f2e09b04214007361e94b5e4d85200546eb67fd8885f72aa236f1",
        type = "tar.gz",
        url = "https://github.com/dtolnay/cxx/archive/refs/tags/1.0.94.tar.gz",
    )

    git_repository(
        name = "com_google_googleapis",
        commit = "af8fe572e00b0f7211b6e6d6c8e8834827f27df9",
        remote = "https://github.com/googleapis/googleapis",
    )
