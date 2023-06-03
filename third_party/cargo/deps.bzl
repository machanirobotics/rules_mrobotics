# buildifier: disable=module-docstring
load("@rules_rust//crate_universe:defs.bzl", "crate")

cargo_info = struct(
    packages = {
        "protoc-gen-tonic": crate.spec(
            version = "0.2.1",
        ),
        "protoc-gen-prost": crate.spec(
            version = "0.2.1",
        ),
        "protoc-gen-prost-crate": crate.spec(
            git = "https://github.com/neoeinstein/protoc-gen-prost",
            rev = "038cd342677dfa869f8c3a2a2787a139fc561df8",
        ),
    },
)

cargo_examples_info = struct(
    packages = {
        "tonic": crate.spec(
            version = "0.9.2",
        ),
        "prost": crate.spec(
            version = "0.11.6",
        ),
    },
)
