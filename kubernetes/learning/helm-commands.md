## Helm
Helm helps you manage Kubernetes application - Helm Charts help you define, install adn upgrade even the most complex application.
Helm is the package manager for Kubernetes.

Charts are easy to create, version, share and publish.

## Helm Commands

Create a new chart with the given name:<br>
helm create NAME [flags]

This command installs a chart archive.
The install argument must be a chart reference, a path to a packaged chart, a path to an unpacked chart directory or a URL.<br>
helm install [NAME] [CHART] [flags]

list releases<br>
helm list [flags]

roll back a release to a previous revision<br>
helm rollback <RELEASE> [REVISION] [flags]

helm install <> --debug --dry-run helloworld

Render chart templates locally and display the output.<br>
helm template [NAME] [CHART] [flags]

This command takes a path to a chart and runs a series of tests to verify that the chart is well-formed.<br>
helm lint PATH [flags]

This command takes a release name and uninstalls the release.<br>
helm uninstall RELEASE_NAME [...] [flags]


## Chart Hooks
Helm provides a hook mechanism to allow chart developers to intervene at certain points in a release's life cycle.
Usually are jobs in helm_chart_name/templates/hooks/hook_filename.yml

  annotations:
    # This is what defines this resource as a hook. Without this line, the
    # job is considered part of the release.
    "helm.sh/hook": post-install
    "helm.sh/hook-weight": "-5"
    "helm.sh/hook-delete-policy": hook-succeeded

## Helm Test
A chart contains a number of Kubernetes resources and components that work together. As a chart author, you may want to write some tests that validate that your chart works as expected when it is installed. These tests also help the chart consumer understand what your chart is supposed to do.

--> Helm chart has to be installed for test to work
helm test demo

## Helmfile
helmfile sync
use the above 1 command to sync the helmfile configuration file