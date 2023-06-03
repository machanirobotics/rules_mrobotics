workspace(name = "rules_mrobotics")

load("//third_party:repositories.bzl", "load_repositories")

load_repositories()

load("//third_party:toolchains.bzl", "load_toolchains")

load_toolchains()

load("//third_party:workspace0.bzl", "init_workspace0")

init_workspace0()

load("//third_party:workspace1.bzl", "init_workspace1")

init_workspace1()

# stuff for examples

######################################################
## rust
load("@rules_rust//crate_universe:defs.bzl", "crates_repository", "render_config")
load("//third_party/cargo:deps.bzl", "cargo_examples_info")

crates_repository(
    name = "rules_mrobotics_examples_crate_index",
    cargo_lockfile = "//third_party/cargo:Cargo.Example.lock",
    generate_binaries = True,
    lockfile = "//third_party/cargo:Cargo.Example.Bazel.lock",
    packages = cargo_examples_info.packages,
    render_config = render_config(
        default_package_name = "",
    ),
)

load("@rules_mrobotics_examples_crate_index//:defs.bzl", "crate_repositories")

crate_repositories()

######################################################
## python
load("@rules_python//python:pip.bzl", "pip_parse")
load("@python//:defs.bzl", "interpreter")

pip_parse(
    name = "rules_mrobotics_pip",
    download_only = True,
    python_interpreter_target = interpreter,
    requirements_lock = "//third_party/pip:requirements.lock",
)

load("@rules_mrobotics_pip//:requirements.bzl", install_py_deps = "install_deps")

install_py_deps()
