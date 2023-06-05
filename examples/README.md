# Examples 

> This folder contains examples for the rules in this repository

Clone the repository and run the examples with bazel

```bash
git clone https://github.com/machanirobotics/rules_mrobotics.git
cd rules_mrobotics/examples
```

## Python 
> This example supports python 3.10 with cross compilation for amd64 and aarch64

+ Run the application with bazel
    ```bash
    bazel run //examples/python:hello_world
    ```
+ Update the dependencies
    ```bash
    bazel run //third_party/pip:requirements.update
    ```
  Note : Update the `third_party/pip/requirements.in` file with the new dependencies
 
## CC 

> This example supports c++14 with cross compilation for amd64 and aarch64 with clang17

+ Run the application with bazel
    ```bash
    bazel run //examples/cc:hello_world
    ```
## Rust

+ Update the dependencies
    ```bash
    bazel sync --only=@rules_mrobotics_examples_crate_index
    ```
+ Run the application with bazel
    ```bash
    bazel run //examples/rust:rocket_example
    ```

## Go

+ Update the dependencies
    ```bash
    bazel run //go:update-repos
    ```
  Note : all dependencies are updated from the `go.mod` file and are dumped to `third_party/go/deps.bzl`

+ Run the application with bazel
    ```bash
    bazel run //examples/go:hello_world
    ```
+ Working with gazelle (TODO: override the default gazelle rule)
    ```bash
    bazel run //go:gazelle
    ```
## Proto

+ Compile for python
    ```bash
    bazel build //examples/proto:greeter_python_grpc
    ``` 
+ Compile for rust
    ```bash
    bazel build //examples/proto:greeter_rust_grpc
    ```
+ Compile for go
    ```bash
    bazel build //examples/proto:proto_go_proto
    ```
## Bundle
+ Bundle the application
    ```bash
    bazel build //examples/bundle:cc_tar
    ```
+ Bootstap binary for the application with `PATH`, `PYTHONHOME`, `PYTHONPATH` and `LD_LIBRARY_PATH`  

    ```bash
    bazel build //examples/bundle:cc_bootstrap
    ``` 
  Note: Useful while working with ffi for python in other languages
