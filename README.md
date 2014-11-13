#docker_registry

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with docker_registry](#setup)
 * [What docker_registry affects](#affected-components)
 * [Setup requirements](#setup-requirements)
 * [getting started with docker_registry](#getting-started)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference) ***coming soon***
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The docker_registry module delploys a private docker registry.

##Module Description

Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications. Consisting of Docker Engine, a portable, lightweight runtime and packaging tool, and Docker Hub, a cloud service for sharing applications and automating workflows, Docker enables apps to be quickly assembled from components and eliminates the friction between development, QA, and production environments. As a result, IT can ship faster and run the same app, unchanged, on laptops, data center VMs, and any cloud.

The Docker registry offers some of the same functionality as the Docker Hub.  It can be installed and administered privately where business, network, and other concerns prohibit the use of a third party hub.

Please note that the deployed registry will be insecure.

##Setup

###affected components

* This module adds the requisite repositories and packages for running the docker registry, then starts the service.
* This is an alpha stage module; not intended for production use.

###Setup Requirements

on ubuntu, make sure ruby 1.9.x is installed.

###getting started

```
wget https://forgeapi.puppetlabs.com/v3/files/markb-docker_registry-0.2.0.tar.gz

puppet module install markb-docker_registry-0.2.0.tar.gz

puppet apply -e 'include docker_registry'
```


you'll want to stop the docker service and start a daemon with the insecure flag:
```
docker -d --insecure-registry localhost:5000
```

then you can use the following to see that the registry is working:
```
docker search tutorial
docker pull learn/tutorial
docker run learn/tutorial apt-get install -y ping
docker ps -a
docker commit <hash from last command> localhost:5000/tutorialWithPing
docker push localhost:5000/tutorialWithPing
```

##Usage

include docker_registry

##Reference

forthcoming

##Limitations

This module will only work for Debian and Rel variants.  It's only been tesed on CentOs 6.5 and Ubuntu 12.04 at this point.  Feedback and errata on other distros/versions is eagerly anticipated.

##Development

Please see the [Github repository](https://github.com/mwbutcher/docker_registry-puppet-module) to contribute.
