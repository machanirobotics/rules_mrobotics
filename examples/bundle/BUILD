load("@rules_mrobotics//bundle:defs.bzl", "bootstrapped_binary", "pkgfy")

pkgfy(
    name = "cc_tar",
    srcs = [
        "//cc:hello_world",
    ],
)

bootstrapped_binary(
    name = "cc_bootstrapped",
    binary = "//cc:hello_world",
)
