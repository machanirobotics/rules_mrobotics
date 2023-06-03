# buildifier: disable=module-docstring
load("//tools/private/hasura:hasura.bzl", _hasura_apply_migration = "apply_migration", _hasura_create_migration = "create_migration", _hasura_export_schema = "export_schema", _hasura_run_console = "run_console")

hasura_create_migration = _hasura_create_migration
hasura_apply_migration = _hasura_apply_migration
hasura_export_schema = _hasura_export_schema
hasura_run_console = _hasura_run_console
