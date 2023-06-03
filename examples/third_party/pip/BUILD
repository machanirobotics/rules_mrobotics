load("@rules_python//python/pip_install:requirements.bzl", "compile_pip_requirements")

exports_files([
    "requirements.lock",
])

compile_pip_requirements(
    name = "requirements",
    extra_args = [
        "--allow-unsafe",
        "--pip-args",
        "'--only-binary=:all:'",
    ],
    requirements_in = "requirements.in",
    requirements_txt = "requirements.lock",
)
