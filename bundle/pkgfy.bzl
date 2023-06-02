def _pkgfy_impl(ctx):
    files = depset()

    # Collect all datafiles of all data
    for dep in ctx.attr.data:
        if hasattr(dep, "data_runfiles"):
            files = depset(transitive = [files, dep.data_runfiles.files])

    # Collect all runfiles of all dependencies
    for dep in ctx.attr.srcs:
        if hasattr(dep, "default_runfiles"):
            files = depset(transitive = [files, dep.default_runfiles.files])
    files = files.to_list()

    exc_files = depset()
    for dep in ctx.attr.excludes:
        if hasattr(dep, "default_runfiles"):
            exc_files = depset(transitive = [exc_files, dep.default_runfiles.files])
    exc_files = exc_files.to_list()

    for f in exc_files:
        if not f.is_source and f in files:
            files.remove(f)

    entrypoint = []

    args = ["--label", str(ctx.label), "--workspace", ctx.workspace_name, "--output", ctx.outputs.out.path]
    if ctx.file.entrypoint:
        args += ["--entrypoint", ctx.file.entrypoint.path]
        entrypoint = [ctx.file.entrypoint]
    args += ["--inputs"] + [f.path for f in files]

    # Create the tar archive
    ctx.actions.run(
        inputs = files + entrypoint,
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
        "packager": attr.label(executable = True, cfg = "exec", default = Label("@rules_mrobotics//pkg/private:package")),
    },
    outputs = {
        "out": "%{name}.%{extension}",
    },
)