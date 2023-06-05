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

## Rust

## Go

## Proto

## Bundle