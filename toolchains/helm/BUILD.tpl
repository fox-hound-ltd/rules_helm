"""This BUILD file is auto-generated from toolchains/helm/BUILD.tpl
"""

package(default_visibility = ["//visibility:public"])

load("@ltd_fox_hound_rules_helm//toolchains/helm:helm_toolchain.bzl", "helm_toolchain")

helm_toolchain(
    name = "toolchain",
%{TOOL_ATTRS}
)
