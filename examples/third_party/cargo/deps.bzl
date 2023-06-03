# buildifier: disable=module-docstring
load("@rules_rust//crate_universe:defs.bzl", "crate")

cargo_info = struct(
    packages = {
        "tonic": crate.spec(
            version = "0.9.2",
        ),
        "prost": crate.spec(
            version = "0.11.6",
        ),
        "prost-types": crate.spec(
            version = "0.11.6",
        ),
    },
)
