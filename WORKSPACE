workspace(name = "rules_mrobotics")

load("//bazel/third_party:rules.bzl", "load_rules")

load_rules()

load("//bazel/third_party:repositories.bzl", "load_repositories")

load_repositories("//:.env")

load("//bazel/third_party:toolchains.bzl", "init_toolchains")

init_toolchains()

load("//bazel/third_party:workspace0.bzl", "init_workspace0")

init_workspace0()

load("//bazel/third_party/go:deps.bzl", "go_dependencies")

# gazelle:repository_macro //bazel/third_party/go/deps.bzl%go_dependencies
go_dependencies()

load("//bazel/third_party:workspace1.bzl", "init_workspace1")

init_workspace1()

