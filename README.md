# rules_mrobotics

[![Build Status](https://travis-ci.org/mRoboticsIO/rules_mrobotics.svg?branch=master)](https://travis-ci.org/mRoboticsIO/rules_mrobotics)

`rules_mrobotics` is a set of [Bazel](https://bazel.build) build rules specifically designed for [mRobotics](https://mrobotics.io) projects.
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
        "github.com/machanirobotics/rules_mrobotics/archive/master.zip",
    ],
)
```
## Rules 

> TODO Documentation 


## Releases

> TODO Make releases

## License

rules_mrobotics is licensed under the terms of the Apache License 2.0. See [LICENSE](LICENSE) for more information.
