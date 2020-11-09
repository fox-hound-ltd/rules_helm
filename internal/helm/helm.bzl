"""
"""

def _helm(
        command_ctx,
        command,
        args = [],
        options = [],
        inputs = []):
    exec_file = command_ctx.actions.declare_file(command_ctx.label.name + "_helm_" + command)

    # Generates the exec bash file with the provided substitutions
    command_ctx.actions.write(
        output = exec_file,
        is_executable = True,
        content = "%s %s %s %s" % (
            command_ctx.toolchains["@ltd_fox_hound_rules_helm//toolchains/helm:toolchain_type"].helminfo.target_tool_path,
            command,
            " ".join(args),
            " ".join(options),
        ),
    )

    runfiles = command_ctx.runfiles(
        files = command_ctx.toolchains["@ltd_fox_hound_rules_helm//toolchains/helm:toolchain_type"].helminfo.tool_files + inputs,
    )

    return [DefaultInfo(
        executable = exec_file,
        runfiles = runfiles,
    )]

def _helm_version_impl(ctx):
    return _helm(ctx, command = "version")

helm_version = rule(
    implementation = _helm_version_impl,
    attrs = {},
    toolchains = ["@ltd_fox_hound_rules_helm//toolchains/helm:toolchain_type"],
    executable = True,
)

def _helm_upgrade_impl(ctx):
    args = [
        ctx.attr.name if ctx.attr.release_name == "" else ctx.attr.release_name,
        ctx.file.chart_tar.path,
    ]
    inputs = [ctx.file.chart_tar]
    options = []

    if len(ctx.attr.namespace) > 0:
        options.append("--namespace %s" % ctx.attr.namespace)
    for variable, value in ctx.attr.values.items():
        options.append("--set %s=%s" % (variable, value))
    if ctx.file.values_yaml_file != None:
        inputs.append(ctx.file.values_yaml_file)
        options.append("--values %s" % ctx.file.values_yaml_file.path)

    return _helm(
        ctx,
        command = "upgrade",
        args = args,
        options = options + ctx.attr.options,
        inputs = inputs,
    )

helm_upgrade = rule(
    implementation = _helm_upgrade_impl,
    attrs = {
        "chart_tar": attr.label(allow_single_file = True, mandatory = True),
        "release_name": attr.string(),
        "namespace": attr.string(),
        "values": attr.string_dict(),
        "values_yaml_file": attr.label(allow_single_file = True),
        "options": attr.string_list(default = []),
    },
    toolchains = ["@ltd_fox_hound_rules_helm//toolchains/helm:toolchain_type"],
    executable = True,
)
