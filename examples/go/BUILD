load("@rules_mrobotics//go:defs.bzl", "go_binary", "go_library")
load("@bazel_gazelle//:def.bzl", "gazelle")

# gazelle:prefix github.com/machanirobotics/bazeltest
gazelle(name = "gazelle")

gazelle(
    name = "update-repos",
    command = "update-repos",
    extra_args = [
        "-from_file=go/go.mod",
        "-to_macro=third_party/go/deps.bzl%go_repositories",
    ],
)

go_library(
    name = "bazeltest_lib",
    srcs = ["main.go"],
    importpath = "github.com/machanirobotics/bazeltest",
    visibility = ["//visibility:private"],
    deps = ["@com_github_gin_gonic_gin//:gin"],
)

go_binary(
    name = "hello-world",
    embed = [":bazeltest_lib"],
    visibility = ["//visibility:public"],
)
