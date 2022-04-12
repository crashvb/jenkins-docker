# jenkins-docker

[![version)](https://img.shields.io/docker/v/crashvb/jenkins/latest)](https://hub.docker.com/repository/docker/crashvb/jenkins)
[![image size](https://img.shields.io/docker/image-size/crashvb/jenkins/latest)](https://hub.docker.com/repository/docker/crashvb/jenkins)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/jenkins-docker.svg)](https://github.com/crashvb/jenkins-docker/blob/master/LICENSE.md)

## Overview

This docker image contains [jenkins](https://jenkins-ci.org/).

## Entrypoint Scripts

### jenkins

The embedded entrypoint script is located at `/etc/entrypoint.d/jenkins and performs the following actions:

1. The PKI certificates are generated or imported.
2. A new jenkins configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | JENKINS\_CERT\_DAYS | 30 | Validity period of any generated PKI certificates. |
 | JENKINS\_KEY\_SIZE | 4096 | Key size of any generated PKI keys. |
 | JENKINS\_PLUGINS | | Comma-separated list of plugin names to be installed. |

## Healthcheck Scripts

### jenkins

The embedded healthcheck script is located at `/etc/healthcheck.d/jenkins` and performs the following actions:

1. Verifies that all jenkins services are operational.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ jenkins/
│  ├─ entrypoint.d/
│  │  └─ jenkins
│  └─ healthcheck.d/
│     └─ jenkins
├─ run/
│  └─ secrets/
│     ├─ jenkins.crt
│     ├─ jenkins.jks
│     ├─ jenkins.key
│     ├─ jenkinsca.crt
│     ├─ jenkins_admin_password
│     └─ jenkins_keystore_password
├─ usr/
│  ├─ local/
│  │  └─ bin/
│  │     └─ jenkins-plugin-cli
│  └─ share/
│     └─ jenkins/
└─ var/
   └─ lib/
      └─ jenkins/
```

### Exposed Ports

* `443/tcp` - Jenkins web server port.
* `50000/tcp` - Jenkins slave port.

### Volumes

* `/var/lib/jenkins` - Jenkins home directory.

## Development

[Source Control](https://github.com/crashvb/jenkins-docker)

