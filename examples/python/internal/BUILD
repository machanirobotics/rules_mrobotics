load("@rules_mrobotics//python:defs.bzl", "py_library")

py_library(
    name = "example_lib",
    srcs = glob(
        [
            "*.py",
        ],
        allow_empty = False,
    ),
    visibility = ["//visibility:public"],
    deps = select({
        "@rules_mrobotics//platforms:is_x86_64": [
            "@rules_mrobotics_example_pip_fastapi//:pkg",
            "@rules_mrobotics_example_pip_uvicorn//:pkg",
        ],
        "@rules_mrobotics//platforms:is_aarch64": [
            "@rules_mrobotics_example_pip_fastapi//:pkg",
            "@rules_mrobotics_example_pip_uvicorn//:pkg",
        ],
    }),
)
