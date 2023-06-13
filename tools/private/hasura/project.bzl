"""
Providers and rules to declare a hasura project
"""

HasuraProjectInfo = provider(
    "A hasura project",
    fields = ["config", "migrations", "metadata", "seeds"],
)

def project_info_to_files(info):
    """
    Gets all the files present in HasuraProjectInfo as a list of files

    Args:
        info: HasuraProjectInfo

    Returns:
        list of files
    """
    files = [info.config]
    files.extend(info.migrations.to_list())
    files.extend(info.metadata.to_list())
    if info.seeds != None:
        files.extend(info.seeds.to_list())

    return files

def _hasura_project_impl(ctx):
    return HasuraProjectInfo(
        config = ctx.file.config,
        migrations = ctx.attr.migrations.files,
        metadata = ctx.attr.metadata.files,
        seeds = ctx.attr.seeds.files if ctx.attr.seeds != None else None,
    )

hasura_project = rule(
    implementation = _hasura_project_impl,
    attrs = {
        "config": attr.label(mandatory = True, allow_single_file = True),
        "migrations": attr.label(mandatory = True),
        "metadata": attr.label(mandatory = True),
        "seeds": attr.label(default = None),
    },
)
