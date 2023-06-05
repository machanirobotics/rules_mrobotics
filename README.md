# rules_mrobotics

[![Build Status](https://travis-ci.org/mRoboticsIO/rules_mrobotics.svg?branch=master)](https://travis-ci.org/mRoboticsIO/rules_mrobotics)

`rules_mrobotics` is a set of [Bazel](https://bazel.build) build rules specifically designed for [Machani Robotics](https://github.com/machanirobotics) projects.
## Overview

- [rules\_mrobotics](#rules_mrobotics)
  - [Overview](#overview)
  - [Setup](#setup)
  - [Rules](#rules)
  - [Releases](#releases)
  - [License](#license)
  
## Setup

To use `rules_mrobotics`, follow these steps:

1. Add the following code to your `WORKSPACE` file to include the necessary external repositories:

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_mrobotics",
    sha256 = "19c4aacca31f59f16c647372b535bda7b317bf4e63ce6b12ebf35c254fba6a37",
    strip_prefix = "rules_mrobotics-1.0.0",
    urls = [
        "https://github.com/machanirobotics/rules_mrobotics/archive/v1.0.0.zip",
    ],
)

load("@rules_mrobotics//third_party:repositories.bzl", "load_repositories")

load_repositories()

load("@rules_mrobotics//third_party:toolchains.bzl", "load_toolchains")
 
load_toolchains() 

load("@rules_mrobotics//third_party:workspace0.bzl", "init_workspace0")

init_workspace0()

load("@rules_mrobotics//third_party:workspace1.bzl", "init_workspace1")

init_workspace1()

```
2. Look at the rules that you want to load with your project

If you are facing any issues, look at the examples folder for the rules. [Examples](https://github.com/machanirobotics/rules_mrobotics/tree/master/examples)

## Rules 

* [rules_cc](cc)
  - cc_library: Creates a C++ library target.
  - cc_binary: Creates a C++ binary target.
  - cc_import: Imports a C++ library as a target.
* [rules_rust](rust)
  - rust_library: Creates a Rust library target.
  - rust_binary: Creates a Rust binary target.
  - rust_cc_bridge: Bridges between C++ and Rust.
* [rules_python](python)
  - py_library: Creates a Python library target.
  - py_binary: Creates a Python binary target.
  - py_test: Creates a Python test target.
* [rules_proto](proto)
  - proto_library: Generates protobuf code for the specified protocol buffer files.
  - rust_grpc_library: Generates Rust code for gRPC services.
  - go_proto_library: Generates Go code for protocol buffers.
  - python_grpc_library: Generates Python code for gRPC services.
* [rules_go](go)
  - go_library: Creates a Go library target.
  - go_binary: Creates a Go binary target.
  - go_test: Creates a Go test target.
  - go_repository: Imports an external Go package as a target.
* [rules_bundle](bundle)
  - bootstrapped_binary: Creates a binary that can bootstrap itself.
  - pkgfy: Packages files into a tarball or zip archive.
  - ld_env: Sets linker flags based on environment variables.
* [rules_repo](repo)
  - s3_file: Downloads a file from an S3 bucket.
  - s3_archive: Downloads and extracts a tarball or zip archive from an S3 bucket.
  - patched_local_repository: Specifies a local repository with patches applied.
* [rules_tools](tools)
  - hasura: CLI tool for managing Hasura projects.
  - hasura_create_migration: Creates a new migration for a Hasura project.
  - hasura_apply_migration: Applies migrations to a Hasura project.
  - hasura_export_schema: Exports the GraphQL schema from a Hasura project.
  - hasura_run_console: Starts a local Hasura GraphQL console.
  

## Releases

| Version | Release Date | Changelog                                                                           |
| ------- | ------------ | ----------------------------------------------------------------------------------- |
| v1.0.0  | 2023-06-05   | [Changelog](https://github.com/machanirobotics/rules_mrobotics/releases/tag/v1.0.0) |

## License

rules_mrobotics is licensed under the terms of the Apache License 2.0. See [LICENSE](LICENSE) for more information.
