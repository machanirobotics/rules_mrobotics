#!/bin/bash

set -eo pipefail

COMMAND="@COMMAND@"

function fatal {
    local red='\033[0;31m'
    local nc='\033[0m'
    >&2 printf "${red}Error${nc}: $1\n"
    exit 1
}

case "$COMMAND" in
    "create_migration")
        cd "$BUILD_WORKSPACE_DIRECTORY/@PACKAGE@"
        rm -rf migrations/*
        hasura migrate create "init" --from-server --schema @SCHEMAS@ --database-name @DATABASE@ --skip-update-check
        ;;
    "apply_migration")
        cd $(dirname @HASURA_CONFIG_PATH@)
        
        hasura metadata apply --skip-update-check
        hasura migrate apply --database-name @DATABASE@ --skip-update-check
        hasura metadata reload --skip-update-check
    
        while IFS= read -r -d $'\0' file; do
            hasura seed apply --file $(basename "$file") --database-name @DATABASE@
        done < <(find -L seeds -type f -iname "*.sql" -print0 | sort -z)
        ;;
    "console")
        cd "$BUILD_WORKSPACE_DIRECTORY/@PACKAGE@"
        hasura console --skip-update-check
        ;;
    "export_schema")
        cd "$BUILD_WORKSPACE_DIRECTORY/@PACKAGE@"
        get-graphql-schema @URL@ > @OUTPUT@
        printf "Done. Schema exported to @PACKAGE@/@OUTPUT@\n"
        ;;
    *)
        fatal "invalid command: $COMMAND"
esac
