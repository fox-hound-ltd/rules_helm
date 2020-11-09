"""Defines a repository rule for configuring the helm executable.
"""

def _impl(repository_ctx):
    substitutions = {"%{TOOL_ATTRS}": "    target_tool = \"%s\"\n" % repository_ctx.attr.target_tool}

    repository_ctx.template(
        "BUILD",
        Label("@ltd_fox_hound_rules_helm//toolchains/helm:BUILD.tpl"),
        substitutions,
        False,
    )

helm_toolchain_configure = repository_rule(
    implementation = _impl,
    attrs = {
        "target_tool": attr.label(
            doc = "Target for a downloaded nodejs binary for the target os.",
            mandatory = True,
            allow_single_file = True,
        ),
    },
    doc = """Creates an external repository with a helm_toolchain //:toolchain target properly configured.""",
)
