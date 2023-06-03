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

> TODO Documentation 


## Releases

| Version | Release Date | Changelog |
|---------|--------------|-----------|
| v1.0.0  | 2023-06-DD  | [Changelog](https://github.com/machanirobotics/rules_mrobotics/releases/tag/v1.0.0) |

## License

rules_mrobotics is licensed under the terms of the Apache License 2.0. See [LICENSE](LICENSE) for more information.
