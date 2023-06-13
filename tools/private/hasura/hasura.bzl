"""
Rules to run various hasura cli commands. Requires the hasura cli and get-graphql-schema to be 
installed.
"""

load("//tools/private/hasura:runner.bzl", "create_runner")
load("//tools/private/hasura:project.bzl", "HasuraProjectInfo", "project_info_to_files")

def _create_migration_impl(ctx):
    runner = create_runner(ctx, "create_migration", {
        "@SCHEMAS@": ",".join(ctx.attr.schemas),
        "@DATABASE@": ctx.attr.database,
    })
    return DefaultInfo(executable = runner)

create_migration = rule(
    implementation = _create_migration_impl,
    attrs = {
        "schemas": attr.string_list(allow_empty = False, mandatory = True),
        "database": attr.string(mandatory = True),
        "_template": attr.label(default = "//tools/private/hasura:hasura_runner_template.sh", allow_single_file = True),
    },
    executable = True,
)

def _run_console_impl(ctx):
    info = ctx.attr.project[HasuraProjectInfo]
    runner = create_runner(ctx, "console", {
        "@HASURA_CONFIG_PATH@": info.config.path,
    })

    return DefaultInfo(
        executable = runner,
        runfiles = ctx.runfiles(project_info_to_files(info)),
    )

run_console = rule(
    implementation = _run_console_impl,
    attrs = {
        "project": attr.label(mandatory = True, providers = [HasuraProjectInfo]),
        "_template": attr.label(default = "//tools/private/hasura:hasura_runner_template.sh", allow_single_file = True),
    },
    executable = True,
)

def _export_schema_impl(ctx):
    runner = create_runner(ctx, "export_schema", {
        "@URL@": ctx.attr.url,
        "@OUTPUT@": ctx.attr.out,
    })
    return DefaultInfo(executable = runner)

export_schema = rule(
    implementation = _export_schema_impl,
    attrs = {
        "url": attr.string(mandatory = True),
        "out": attr.string(mandatory = True),
        "_template": attr.label(default = "//tools/private/hasura:hasura_runner_template.sh", allow_single_file = True),
    },
    executable = True,
)

def _apply_migration_impl(ctx):
    info = ctx.attr.project[HasuraProjectInfo]
    runner = create_runner(ctx, "apply_migration", {
        "@DATABASE@": ctx.attr.database,
        "@HASURA_CONFIG_PATH@": info.config.path,
    })

    return DefaultInfo(
        executable = runner,
        runfiles = ctx.runfiles(project_info_to_files(info)),
    )

apply_migration = rule(
    implementation = _apply_migration_impl,
    attrs = {
        "_template": attr.label(default = "//tools/private/hasura:hasura_runner_template.sh", allow_single_file = True),
        "database": attr.string(mandatory = True),
        "project": attr.label(mandatory = True, providers = [HasuraProjectInfo]),
    },
    executable = True,
)
