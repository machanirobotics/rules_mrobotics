"""
Local repository rule that supports patches
"""

def _patched_local_repository_impl(repository_ctx):
    archive = repository_ctx.attr.name + ".tar"
    reference = Label("@%s_unpatched//:WORKSPACE" % repository_ctx.attr.name)
    dirname = repository_ctx.path(reference).dirname
    repository_ctx.execute(["tar", "hcf", archive, "-C", dirname, "."])
    repository_ctx.extract(archive)
    for patch in repository_ctx.attr.patches:
        repository_ctx.patch(repository_ctx.path(patch), repository_ctx.attr.patch_strip)

_patched_local_repository_rule = repository_rule(
    implementation = _patched_local_repository_impl,
    attrs = {
        "patches": attr.label_list(),
        "patch_strip": attr.int(),
        "build_file": attr.label(),
    },
)

def patched_local_repository(name, path, add_empty_build_file = False, **kwargs):
    if add_empty_build_file:
        native.new_local_repository(
            name = name + "_unpatched",
            path = path,
            build_file_content = "",
        )
    else:
        native.local_repository(
            name = name + "_unpatched",
            path = path,
        )

    _patched_local_repository_rule(name = name, **kwargs)
