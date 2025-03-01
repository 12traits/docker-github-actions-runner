# hadolint ignore=DL3007
FROM europe-west1-docker.pkg.dev/original-list-207312/solsten/github-runner-base:master
LABEL maintainer="myoung34@my.apsu.edu"

ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
RUN mkdir -p /opt/hostedtoolcache

ARG GH_RUNNER_VERSION="2.322.0"
ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /actions-runner
COPY install_actions.sh /actions-runner
RUN chmod +x /actions-runner/install_actions.sh \
    && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
    && rm /actions-runner/install_actions.sh \
    && chown runner /_work /actions-runner /opt/hostedtoolcache

COPY token.sh entrypoint.sh app_token.sh wrapper.sh /
RUN chmod +x /token.sh /entrypoint.sh /app_token.sh /wrapper.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/wrapper.sh"]
