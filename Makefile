SHELL=/usr/bin/env bash -o errexit

export CONTAINER_ENGINE ?= docker

new-repo:
	$(SKIP_PULL) || $(CONTAINER_ENGINE) pull registry.ci.openshift.org/ci/repo-init:latest
	$(CONTAINER_ENGINE) run $(USER) --platform linux/amd64 --rm -it -v "$(CURDIR):/release:z" registry.ci.openshift.org/ci/repo-init:latest --release-repo /release
	$(MAKE) update
# ^ taken from openshift/release, doesn't actually work right now.