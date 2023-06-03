"""
s3 related rules
"""

def _s3_download(ctx, tool, region, env, output, s3_path):
    ctx.report_progress("Downloading file")
    res = ctx.execute(
        [
            "/bin/bash",
            tool,
            "-r",
            region,
            "-e",
            env,
            "-o",
            output,
            s3_path,
        ],
        timeout = 10000,
    )
    ctx.report_progress("File downloaded")
    return res

def _s3_archive_impl(repository_ctx):
    """
    Implementation of s3_archive rule

    Args:
        repository_ctx: the repo context
    """
    attr = repository_ctx.attr
    if attr.build_file and attr.build_file_contents:
        fail("Cannot give both build_file and build_file_contents")

    archive = attr.file.split("/")[-1]
    s3_path = "/" + attr.bucket + "/" + attr.file

    res = _s3_download(repository_ctx, repository_ctx.path(attr.tool), attr.region, repository_ctx.path(attr.env), archive, s3_path)

    if res.return_code != 0:
        fail("Failed to download " + s3_path + " with exit code " + str(res.return_code))

    repository_ctx.extract(
        archive = archive,
        stripPrefix = attr.strip_prefix,
    )

    for patch in attr.patches:
        repository_ctx.patch(repository_ctx.path(patch), attr.patch_strip)

    if attr.build_file:
        build_file = repository_ctx.path(attr.build_file)
        repository_ctx.execute(["cp", build_file, "BUILD.bazel"])
    elif attr.build_file_contents:
        repository_ctx.file(
            "BUILD",
            content = attr.build_file_contents,
            executable = False,
        )

s3_archive = repository_rule(
    implementation = _s3_archive_impl,
    attrs = {
        "bucket": attr.string(mandatory = True),
        "file": attr.string(mandatory = True),
        "region": attr.string(mandatory = True),
        "patches": attr.label_list(),
        "patch_strip": attr.int(),
        "build_file": attr.label(),
        "build_file_contents": attr.string(),
        "strip_prefix": attr.string(),
        "env": attr.label(allow_single_file = True, mandatory = True),
        "tool": attr.label(executable = True, cfg = "exec", allow_single_file = True, default = "//repo/private:s3-get"),
    },
)

def _s3_file_impl(repository_ctx):
    """
    Implementation of s3_archive rule

    Args:
        repository_ctx: the repo context
    """
    attr = repository_ctx.attr
    archive = attr.file.split("/")[-1]
    s3_path = "/" + attr.bucket + "/" + attr.file

    res = _s3_download(repository_ctx, repository_ctx.path(attr.tool), attr.region, repository_ctx.path(attr.env), archive, s3_path)

    if res.return_code != 0:
        fail("Failed to download " + s3_path + " with exit code " + str(res.return_code))

    if attr.build_file != None:
        build_file = repository_ctx.path(attr.build_file)
        repository_ctx.execute(["cp", build_file, "BUILD.bazel"])
    else:
        repository_ctx.file("BUILD.bazel", attr.build_file_contents)

s3_file = repository_rule(
    implementation = _s3_file_impl,
    attrs = {
        "bucket": attr.string(mandatory = True),
        "file": attr.string(mandatory = True),
        "region": attr.string(mandatory = True),
        "build_file": attr.label(),
        "build_file_contents": attr.string(default = """

filegroup(
    name = "data",
    srcs = glob(
        [
            "*"
        ],
        exclude = [
            "BUILD.bazel",
            "BUILD",
            "WORKSPACE",
        ]
    ),
    visibility = [ "//visibility:public" ]
)
        """),
        "env": attr.label(allow_single_file = True, mandatory = True),
        "tool": attr.label(executable = True, cfg = "exec", allow_single_file = True, default = "//repo/private:s3-get"),
    },
)
