FROM python:3.9-alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.title="bdwyertech/gitlab-mirror-sync" \
      org.opencontainers.image.version=$VCS_REF \
      org.opencontainers.image.description="For mirroring GitHub to GitLab" \
      org.opencontainers.image.authors="Brian Dwyer <bdwyertech@github.com>" \
      org.opencontainers.image.url="https://hub.docker.com/r/bdwyertech/gitlab-mirror-sync" \
      org.opencontainers.image.source="https://github.com/bdwyertech/docker-gitlab-mirror-sync.git" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.name="bdwyertech/gitlab-mirror-sync" \
      org.label-schema.description="For mirroring Github to GitLab" \
      org.label-schema.url="https://hub.docker.com/r/bdwyertech/gitlab-mirror-sync" \
      org.label-schema.vcs-url="https://github.com/bdwyertech/docker-gitlab-mirror-sync.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE

ENV PYTHONUNBUFFERED 1

ADD requirements.txt .
RUN apk add --no-cache bash git curl openjdk8-jre-base \
    && apk add --no-cache --virtual .build-deps build-base libffi-dev \
    && python -m pip install --upgrade pip \
    && python -m pip install -r requirements.txt \
    && apk del .build-deps \
    && rm requirements.txt \
    && rm -rf ~/.cache/pip \
    && adduser git -S -h /home/git

RUN curl -sfL https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar > /usr/share/bfg.jar
ADD bfg.sh /usr/local/bin/bfg

USER git
WORKDIR /home/git
CMD ["bash"]
