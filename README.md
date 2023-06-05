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
    strip_prefix = "rules_mrobotics-master",
    urls = [
        "https://github.com/machanirobotics/rules_mrobotics/archive/master.zip",
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
  * cc_library
  * cc_binary
  * cc_import
* [rules_rust](rust)
  * rust_library
  * rust_binary
  * rust_cc_bridge
* [rules_python](python)
  * py_library 
  * py_binary
  * py_test
* [rules_proto](proto)
  * proto_library
  * rust_grpc_library
  * go_proto_library
  * python_grpc_library
* [rules_go](go)
  * go_library
  * go_binary
  * go_test
  * go_repository
* [rules_bundle](bundle)
  * bootstrapped_binary
  * pkgfy
  * ld_env
* [rules_repo](repo)
  * s3_file
  * s3_archive
  * patched_local_repository
* [rules_tools](tools)
  * Hasura
    * hasura_create_migration
    * hasura_apply_migration
    * hasura_export_schema
    * hasura_run_console
  

## Releases

| Version | Release Date | Changelog                                                                           |
| ------- | ------------ | ----------------------------------------------------------------------------------- |
| v1.0.0  | 2023-06-DD   | [Changelog](https://github.com/machanirobotics/rules_mrobotics/releases/tag/v1.0.0) |

## License

rules_mrobotics is licensed under the terms of the Apache License 2.0. See [LICENSE](LICENSE) for more information.
