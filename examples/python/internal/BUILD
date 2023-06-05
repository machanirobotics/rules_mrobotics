load("@rules_mrobotics//python:defs.bzl", "py_library")

py_library(
    name = "example_lib",
    srcs = glob(
        [
            "*.py",
        ],
        allow_empty = False,
    ),
    deps = select({
        "@rules_mrobotics//platforms:is_x86_64": [
            "@rules_mrobotics_pip_uvicorn//:pkg",
            "@rules_mrobotics_pip_fastapi//:pkg"
        ],
        "@rules_mrobotics//platforms:is_aarch64": [
            "@rules_mrobotics_pip_uvicorn//:pkg",
            "@rules_mrobotics_pip_fastapi//:pkg"
        ],
    }),
    visibility = ["//visibility:public"],
)