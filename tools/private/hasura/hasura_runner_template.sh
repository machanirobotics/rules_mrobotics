#!/bin/bash

set -eo pipefail

cd "$BUILD_WORKSPACE_DIRECTORY/@PACKAGE@"
COMMAND="@COMMAND@"

function fatal {
    local red='\033[0;31m'
    local nc='\033[0m'
    >&2 printf "${red}Error${nc}: $1\n"
    exit 1
}

case "$COMMAND" in
    "create_migration")
        rm -rf migrations/*
        hasura migrate create "init" --from-server --schema @SCHEMAS@ --database-name @DATABASE@ --skip-update-check
        ;;
    "apply_migration")
        hasura metadata apply --skip-update-check
        hasura migrate apply --database-name @DATABASE@ --skip-update-check
        hasura metadata reload --skip-update-check
        find seeds -type f -iname "*.sql" -exec sh -c 'hasura seed apply --file `basename "$1"` --database-name @DATABASE@' sh {} \;
        ;;
    "console")
        hasura console --skip-update-check
        ;;
    "export_schema")
        get-graphql-schema @URL@ > @OUTPUT@
        printf "Done. Schema exported to @PACKAGE@/@OUTPUT@\n"
        ;;
    *)
        fatal "invalid command: $COMMAND"
esac
