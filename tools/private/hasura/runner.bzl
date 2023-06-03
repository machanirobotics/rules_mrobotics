# buildifier: disable=module-docstring
def create_runner(ctx, command, substitutions):
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
