"""
Helper functions for hasura
"""

def create_runner(ctx, command, substitutions):
    """
    Creates the runner script to run a hasura command from the runner template

    Args:
        ctx: the caller's rule context
        command: the tag of the command to run
        substitutions: additional template substitutions

    Returns:
        the created runner script
    """

    template = ctx.file._template
    out_name = "%s_runner.sh" % command
    runner = ctx.actions.declare_file(out_name)
    substitutions.update({
        "@COMMAND@": command,
        "@PACKAGE@": ctx.label.package,
    })
    ctx.actions.expand_template(
        template = template,
        output = runner,
        substitutions = substitutions,
    )

    return runner
