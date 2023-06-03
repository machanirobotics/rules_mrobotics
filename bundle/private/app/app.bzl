# buildifier: disable=module-docstring
load(":ld_env.bzl", "LdEnvInfo")

def _gen_bootstrap_script_impl(ctx):
    # getting python interpreter files, python import paths and the files of
    # the python libraries being used
    py_toolchain = ctx.toolchains["@bazel_tools//tools/python:toolchain_type"]
    py_interpreter_files = py_toolchain.py3_runtime.files.to_list()
    py_libraries_files = []
    py_import_paths = []
    for pkg in ctx.attr.py_libraries:
        py_libraries_files.extend(pkg.default_runfiles.files.to_list())
        for p in pkg[PyInfo].imports.to_list():
            path = "external/" + p
            if p not in py_import_paths:
                py_import_paths.append(path)

    # getting files for ld_library_path
    ld_library_path = ""
    ld_library_path_runfiles = []
    for target in ctx.attr.ld_env:
        paths = target[LdEnvInfo].paths
        if len(paths) != 0:
            paths_as_str = ":".join(paths)
            if ld_library_path == "":
                ld_library_path = paths_as_str
            else:
                ld_library_path = "%s:%s" % (ld_library_path, paths_as_str)
        ld_library_path_runfiles.append(target[DefaultInfo].default_runfiles)

    binary_files = ctx.attr.binary.default_runfiles.files.to_list()
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = ctx.outputs.out,
        substitutions = {
            "@PYTHON_INTERPRETER_PATH@": py_toolchain.py3_runtime.interpreter.path,
            "@PYTHONPATH@": ":".join(py_import_paths),
            "@APP@": ctx.executable.binary.path.removeprefix(ctx.bin_dir.path).lstrip("/"),
            "@LD_LIBRARY_PATH@": ld_library_path,
        },
        is_executable = True,
    )

    bootstrap_runfiles = ctx.runfiles(py_interpreter_files + binary_files + py_libraries_files)
    bootstrap_runfiles = bootstrap_runfiles.merge_all(ld_library_path_runfiles)
    return DefaultInfo(
        runfiles = bootstrap_runfiles,
    )

_gen_bootstrap_script = rule(
    implementation = _gen_bootstrap_script_impl,
    attrs = {
        "binary": attr.label(executable = True, mandatory = True, cfg = "target"),
        "py_libraries": attr.label_list(default = []),
        "ld_env": attr.label_list(default = [], providers = [DefaultInfo, LdEnvInfo]),
        "out": attr.output(mandatory = True),
        "_template": attr.label(allow_single_file = True, default = "//bundle/private/app:bootstrap.tpl"),
    },
    toolchains = [
        "@bazel_tools//tools/python:toolchain_type",
    ],
)

def bootstrapped_binary(name, binary, py_libraries = [], ld_env = [], visibility = []):
    _gen_bootstrap_script(
        name = name + ".bootstrapper",
        out = "bootstrap.sh",
        binary = binary,
        ld_env = ld_env,
        py_libraries = py_libraries,
    )

    native.sh_binary(
        name = name,
        srcs = [
            ":bootstrap.sh",
        ],
        data = [
            name + ".bootstrapper",
        ],
        visibility = visibility,
    )
