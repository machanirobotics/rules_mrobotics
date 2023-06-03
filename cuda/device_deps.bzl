# buildifier: disable=module-docstring
CUDA_SO = [
    "cudart",
    "cufft",
    "curand",
    "cusolver",
    "cusparse",
    "nvgraph",
    "nvrtc",
]

NPP_SO = [
    "nppc",
    "nppial",
    "nppicc",
    "nppicom",
    "nppidei",
    "nppif",
    "nppig",
    "nppim",
    "nppist",
    "nppisu",
    "nppitc",
    "npps",
]

# Get the path for the shared library with given name for the given version
def cuda_so_path(name, version):
    return "usr/local/cuda-" + version + "/lib64/lib" + name + ".so*"

# Get the path for libcuda.so for the given version. A stub is used as the library is provided
# by the CUDA driver and is required to be available on the system.
def cuda_driver_so_path(family, version):
    return "usr/local/cuda-" + version + "/targets/" + family + "-linux/lib/stubs/libcuda.so"

# Get the path for libnvToolsExt.so for the given version. A stub is used as the library is provided
# by the CUDA driver and is required to be available on the system.
def cuda_nv_tools_ext_so_path(family, version):
    return "usr/local/cuda-" + version + "/targets/" + family + "-linux/lib/libnvToolsExt.so.1"

# Creates CUDA related dependencies. The arguments `family` and `version` are used to find the
# library and header files in the package
# buildifier: disable=unnamed-macro
# buildifier: disable=function-docstring
def cuda_device_deps(family, version):
    cuda_include_prefix = "usr/local/cuda-" + version + "/targets/" + family + "-linux/include"

    if family == "aarch64" and version.startswith("11."):
        CUDA_SO_LIST = CUDA_SO + ["cudla"]
    else:
        CUDA_SO_LIST = CUDA_SO

    # CUDA
    cuda_hdrs = native.glob([
        # FIXME separate out headers
        cuda_include_prefix + "/*.h",
        cuda_include_prefix + "/*.hpp",
        cuda_include_prefix + "/CL/*.h",
        cuda_include_prefix + "/crt/*",
    ])

    # Create a stub library for the CUDA base library provided by the driver
    native.cc_library(
        name = "cuda",
        hdrs = cuda_hdrs,
        srcs = [cuda_driver_so_path(family, version), cuda_nv_tools_ext_so_path(family, version)],
        strip_include_prefix = cuda_include_prefix,
        visibility = ["//visibility:public"],
    )

    # Create one library per CUDA shared libray
    for so in CUDA_SO_LIST:
        native.cc_library(
            name = so,
            hdrs = cuda_hdrs,
            srcs = native.glob([cuda_so_path(so, version)]),
            strip_include_prefix = cuda_include_prefix,
            visibility = ["//visibility:public"],
            linkopts = [
                "-Wl,--no-as-needed," +
                "-l:lib" + so + ".so," +
                "--as-needed",
            ],
        )

    # NPP
    npp_hdrs = native.glob([cuda_include_prefix + "/npp*.*"])  # FIXME separate out headers
    for so in NPP_SO:
        native.cc_library(
            name = so,
            hdrs = npp_hdrs,
            srcs = native.glob([cuda_so_path(so, version)]),
            # Dependency graph: nppc <- npps <- everything else
            deps = ["cudart"] +
                   ["nppc"] if so != "nppc" else [] +
                                                 ["npps"] if so != "npps" and so != "nppc" else [],
            strip_include_prefix = cuda_include_prefix,
            linkopts = [
                "-Wl,--no-as-needed," +
                "-l:lib" + so + ".so," +
                "--as-needed",
            ],
            visibility = ["//visibility:public"],
        )

    # THRUST CUDA Library.  Note: CUB template library is included into THRUST
    # library (as in CUDA 10).  With CUDA 10 support removal, it can be moved
    # into a separate library.
    native.cc_library(
        name = "thrust",
        hdrs = native.glob([
            cuda_include_prefix + "/thrust/**/*",
            cuda_include_prefix + "/cub/**/*",
        ]),
        deps = ["cudart"],
        strip_include_prefix = cuda_include_prefix,
        visibility = ["//visibility:public"],
    )

    # CUBLAS
    if version == "10.2":
        native.cc_library(
            name = "cublas",
            hdrs = native.glob(["usr/include/cublas*.h"]),
            srcs = native.glob(["usr/lib/" + family + "-linux-gnu/libcublas*.so*"]),
            strip_include_prefix = "usr/include",
            visibility = ["//visibility:public"],
            linkopts = [
                "-Wl,--no-as-needed," +
                "-l:libcublasLt.so,-l:libcublas.so," +
                "--as-needed",
            ],
        )
    else:
        native.cc_library(
            name = "cublas",
            hdrs = native.glob([cuda_include_prefix + "/cublas*.h"]),
            srcs = native.glob(["usr/local/cuda-" + version + "/lib64/libcublas*.so*"]),
            strip_include_prefix = cuda_include_prefix,
            visibility = ["//visibility:public"],
            linkopts = [
                "-Wl,--no-as-needed," +
                "-l:libcublasLt.so,-l:libcublas.so," +
                "--as-needed",
            ],
        )

    # CUDNN
    native.cc_library(
        name = "cudnn",
        hdrs = native.glob(["usr/include/" + family + "-linux-gnu/cudnn*.h"]),
        includes = ["usr/include/" + family + "-linux-gnu"],
        strip_include_prefix = "usr/include/" + family + "-linux-gnu",
        srcs = native.glob(["usr/lib/" + family + "-linux-gnu/libcudnn*.so*"]),
        deps = ["cudart"],
        linkstatic = True,
        linkopts = [
            "-Wl,--no-as-needed," +
            "-l:libcudnn.so.8," +
            "--as-needed",
        ],
        visibility = ["//visibility:public"],
    )

# Selects the correct version of `target` based on the current platform
def _cuda_select(target):
    return select({
        "@rules_mrobotics//platforms:is_x86_64": ["@cuda_x86_64//:" + target],
        "@rules_mrobotics//platforms:is_aarch64": ["@cuda_aarch64//:" + target],
    })

# Creates all CUDA related dependencies for the current platform
# buildifier: disable=unnamed-macro
# buildifier: disable=function-docstring
def cuda_deps():
    TARGETS = ["cuda", "cublas"] + CUDA_SO + NPP_SO + ["cudnn", "thrust"]
    for target in TARGETS:
        native.cc_library(
            name = target,
            visibility = ["//visibility:public"],
            deps = _cuda_select(target),
        )
