FROM crashvb/supervisord:202303031721@sha256:6ff97eeb4fbabda4238c8182076fdbd8302f4df15174216c8f9483f70f163b68
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:6ff97eeb4fbabda4238c8182076fdbd8302f4df15174216c8f9483f70f163b68" \
	org.opencontainers.image.base.name="crashvb/supervisord:202303031721" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing jenkins." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/jenkins-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/jenkins" \
	org.opencontainers.image.url="https://github.com/crashvb/jenkins-docker"

# Install packages, download files ...
RUN mkdir --parents /usr/share/man/man1/ && \
	docker-apt curl git gnupg jq openjdk-11-jre-headless openssh-client ssl-cert unzip && \
	rm --force --recursive /usr/share/man

# Configure: jenkins
ENV \
	JENKINS_GID=1000 \
	JENKINS_HOME=/var/lib/jenkins \
	JENKINS_SHARE=/usr/share/jenkins \
	JENKINS_SLAVE_PORT=50000 \
	JENKINS_UID=1000 \
	JENKINS_VERSION=2.445 \
	JENKINS_VERSION_CLI=2.12.15
COPY jenkins-plugin-cli /usr/local/bin/
ARG jenkins_plugins="configuration-as-code git job-dsl pipeline-model-definition workflow-cps workflow-job"
RUN groupadd --gid=${JENKINS_GID} jenkins && \
	useradd --gid=${JENKINS_GID} --groups=ssl-cert --home-dir=${JENKINS_HOME} --no-create-home --uid=${JENKINS_UID} jenkins && \
	mkdir --parents ${JENKINS_SHARE} && \
	wget --output-document=${JENKINS_SHARE}/jenkins.war.${JENKINS_VERSION} --quiet \
		https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war && \
	wget --output-document=${JENKINS_SHARE}/jenkins-plugin-manager.jar.${JENKINS_VERSION_CLI} --quiet \
		https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${JENKINS_VERSION_CLI}/jenkins-plugin-manager-${JENKINS_VERSION_CLI}.jar && \
	ln --symbolic "${JENKINS_SHARE}/jenkins-plugin-manager.jar.${JENKINS_VERSION_CLI}" "${JENKINS_SHARE}/jenkins-plugin-manager.jar" && \
	ln --symbolic "${JENKINS_HOME}/jenkins.war" "${JENKINS_SHARE}/jenkins.war" && \
	ln --symbolic "${JENKINS_HOME}/jenkins.war.bak" "${JENKINS_SHARE}/jenkins.war.bak" && \
	ln --symbolic "${JENKINS_HOME}/jenkins.war.tmp" "${JENKINS_SHARE}/jenkins.war.tmp" && \
	jenkins-plugin-cli --latest --latest-specified --plugins ${jenkins_plugins} --view-security-warnings --war ${JENKINS_SHARE}/jenkins.war.${JENKINS_VERSION} && \
	echo "JENKINS_HOME=${JENKINS_HOME}" >> /etc/environment

# Configure: supervisor
COPY supervisord.jenkins.conf /etc/supervisor/conf.d/jenkins.conf

# Configure: entrypoint
COPY entrypoint.jenkins /etc/entrypoint.d/jenkins

# Configure: healthcheck
COPY healthcheck.jenkins /etc/healthcheck.d/jenkins

EXPOSE 443/tcp 50000/tcp

VOLUME ${JENKINS_HOME}
