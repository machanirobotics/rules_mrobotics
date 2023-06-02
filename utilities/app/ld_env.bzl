# buildifier: disable=module-docstring
LdEnvInfo = provider(
    "Info needed to generate ld library path",
    fields = {
        "paths": "ld library path entries",
    },
)

def _ld_env_impl(ctx):
    ld_lib_path = []
    ld_lib_path_files = []
    for target in ctx.attr.srcs:
        for file in target.data_runfiles.files.to_list():
            if file.is_source or not file.short_path.startswith("_solib"):
                continue

            candidate_ld_lib_path = file.dirname.lstrip(ctx.bin_dir.path)
            if candidate_ld_lib_path not in ld_lib_path:
                ld_lib_path.append(candidate_ld_lib_path)

            if file not in ld_lib_path_files:
                ld_lib_path_files.append(file)

    runfiles = ctx.runfiles(files = ld_lib_path_files)

    return [
        LdEnvInfo(
            paths = ld_lib_path,
        ),
        DefaultInfo(
            runfiles = runfiles,
        ),
    ]

ld_env = rule(
    implementation = _ld_env_impl,
    attrs = {
        "srcs": attr.label_list(default = [], providers = [CcInfo]),
    },
)
