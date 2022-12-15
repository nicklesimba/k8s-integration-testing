# Kubernetes Release Tooling

(This is a stub readme - please disregard for now)

This repository holds Kubernetes CI workflow configuration for Kubernetes component repositories in Kubernetes Network Plumbing Working Group.

## CI Workflow Configuration

To setup a CI workflow for a new repository, use `make new-repo`. See the
[Contributing CI Configuration to the openshift/release Repository](https://docs.ci.openshift.org/docs/how-tos/contributing-openshift-release/)
document for detailed information about how to contribute to this repository.

<!-- ^ i need to start with a makefile. i also need to create docs for everything. -->

Configuration files for CI workflows live under [`ci-operator/`](./ci-operator/)
and are split into the following categories:

 - [`ci-operator/config`](./ci-operator/config/) contains configuration for the
   `ci-operator`, detailing builds and tests for component repositories.
 - [`ci-operator/jobs`](./ci-operator/jobs/) contains configuration for `prow`,
   detailing job triggers. In almost all cases, this configuration is
   generated automatically from the `ci-operator` config. For manual edits, see
   [this section](https://docs.ci.openshift.org/docs/how-tos/contributing-openshift-release/#component-ci-configuration)
   of the contribution document and the [upstream configuration document](https://github.com/kubernetes/test-infra/blob/master/prow/README.md#how-to-add-new-jobs). Prefer the `ci-operator` config whenever possible.
 - [`ci-operator/step-registry`](./ci-operator/step-registry/) contains the
   registry of reusable test steps and workflows. See the documentation for
   this content [here](https://docs.ci.openshift.org/docs/architecture/step-registry/).

<!-- ^ The above section is what i should try modeling my jobs off of i think. -->