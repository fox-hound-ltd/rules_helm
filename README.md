# Rules helm

## Setup

Add the following to your WORKSPACE file to add the external repositories:

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "ltd_fox_hound_rules_helm",
    strip_prefix = "rules_helm-0.0.1",
    urls = ["https://github.com/fox-hound-ltd/rules_helm/releases/download/v0.0.1/rules_helm-0.0.1.tar.gz"],
    sha256 = "acdf71881c3404c49be1ef0c8e71f93ab9a910b4b3afdebca21d98034778b62e",
)

load("@ltd_fox_hound_rules_helm//:index.bzl", "helm_chart", "helm_repositories")

helm_repositories()

helm_chart(
    name = "jenkins",
    chartname = "jenkins",
    repo_url = "https://charts.jenkins.io",
    version = "2.15.1",
)
```

## Usage

Release helm chart on your BUILD.bazel file

```python
load("@ltd_fox_hound_rules_helm//:index.bzl", "helm_upgrade")

helm_upgrade(
    name = "jenkins",
    chart_tar = "@jenkins//:chart",
    namespace = "<application_namespace>",
    release_name = "jenkins",
    values_yaml_file = "jenkins-values.yaml",
)
```
