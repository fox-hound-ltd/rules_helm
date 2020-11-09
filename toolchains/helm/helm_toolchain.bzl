"""This module implements the helm toolchain rule.
"""

HelmInfo = provider(
    doc = "Information about how to invoke the helm executable.",
    fields = {
        "target_tool_path": "Path to the helm executable for the target platform.",
        "tool_files": """Files required in runfiles to make the helm executable available.""",
    },
)

def _helm_toolchain_impl(ctx):
    tool_files = ctx.attr.target_tool.files.to_list()
    target_tool_path = tool_files[0].short_path
    return [
        platform_common.ToolchainInfo(
            helminfo = HelmInfo(
                target_tool_path = target_tool_path,
                tool_files = tool_files,
            ),
        ),
        platform_common.TemplateVariableInfo({
            "HELM_PATH": target_tool_path,
        }),
    ]

helm_toolchain = rule(
    implementation = _helm_toolchain_impl,
    attrs = {
        "target_tool": attr.label(
            doc = "A hermetically downloaded helm executable target for the target platform.",
            mandatory = True,
            allow_single_file = True,
        ),
    },
    doc = """Defines a helm toolchain.
For usage see https://docs.bazel.build/versions/master/toolchains.html#defining-toolchains.
""",
)
