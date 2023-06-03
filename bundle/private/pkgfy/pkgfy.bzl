"""
A packaging rule that creates a tar archive that contains the runfiles tree of 
a target.
"""

def _pkgfy_impl(ctx):
    # collecting runfiles
    runfiles_list = {}
    for dep in ctx.attr.data:
        runfiles_list = runfiles_list | {f: True for f in dep.default_runfiles.files.to_list()}

    for dep in ctx.attr.srcs:
        runfiles_list = runfiles_list | {f: True for f in dep.default_runfiles.files.to_list()}

    exc_files = {}
    for dep in ctx.attr.excludes:
        exc_files = exc_files | {f: True for f in dep.default_runfiles.files.to_list()}

    for f, _ in exc_files:
        if not f.is_source and f in runfiles_list:
            runfiles_list.pop(f)

    entrypoint = []

    args = ["--label", str(ctx.label), "--workspace", ctx.workspace_name, "--output", ctx.outputs.out.path]
    if ctx.file.entrypoint:
        args += ["--entrypoint", ctx.file.entrypoint.path]
        entrypoint = [ctx.file.entrypoint]
    args += ["--inputs"] + [f.path for f in runfiles_list.keys()]

    # Create the tar archive
    ctx.actions.run(
        inputs = runfiles_list.keys() + entrypoint,
        outputs = [ctx.outputs.out],
        executable = ctx.executable.packager,
        arguments = args,
        use_default_shell_env = True,
    )

# A rule which creates a tar package with the executable and all necessary runfiles compared to
# pkg_tar which needs manual dependency tracing.
pkgfy = rule(
    implementation = _pkgfy_impl,
    executable = False,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "data": attr.label_list(allow_files = True),
        "extension": attr.string(default = "tar"),
        "entrypoint": attr.label(allow_single_file = True),
        "excludes": attr.label_list(allow_files = True),
        "packager": attr.label(executable = True, cfg = "exec", default = Label("//bundle/private/pkgfy:package")),
    },
    outputs = {
        "out": "%{name}.%{extension}",
    },
)
