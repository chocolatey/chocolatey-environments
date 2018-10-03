# How To Use Package Internalizer To Create Internal Package Source (Business Editions Only)

When running within an organization it is beneficial to use your own, internally controlled, package repository. But that doesn't mean you have to create all packages from scratch. Chocolatey allows you to create packages easily using the package builder but it also allows you to take packages from the Chocolatey Community Repository and recompile them for internal use - this is a process known as package internalization.

[This guide](https://chocolatey.org/docs/how-to-setup-internal-package-repository "How To Use Package Internalizer To Create Internal Package Source") shows you how to use that within your organization.

The step by step instructions in that guide are automated in this Vagrant environment for you to use.

## Servers

This Vagrant environment has three servers with the following specifications:

* Windows Server 2016
* 2GB RAM
* 1 vCPU

The server names and descriptions are:

* Production Respository Server
    * Name: prodrepo-srv
    * IP: 10.10.13.14

* Test Repository Server:
    * Name: testrepo-srv
    * IP: 10.10.13.12

* Jenkins Server:
    * Hostname: jenkins-srv
    * IP: 10.10.13.15

Each server is running Windows Server 2016 and has the [standard software](/README.md#standard-sofware) installed.

## Get Started

Before you start ensure you have completed the [prerequisites](/README.md#prerequisites).

Run the `SetupResources.ps1` file in this folder. This will internalize any packages needed for the environment.

Run `vagrant up` from this folder and you will bring up the three servers.

At the very end of the `vagrant up` process you will see a username and password. You can use this to log into Jenkins using `https://localhost:8080` from your guest computer.

## Notes

* Internet access is required to build this environment;
* Jenkins is configured with a default configuration that has the same password for all installations. As this is a temporary environment to be used for **experimentation and testing purposes only** it is not intended, or should be used, in a production environment!

## Known Working Versions

Below we have listed the version that are known to work with this environment. With different versions your mileage may vary.

This environment was built with the following software and versions:

* Vagrant - v2.1.5
* Virtualbox - v5.2.18
* Windows 10 Pro v1803 (Build 17134.285)

And the following Vagrant box(es):

* StefanScherer/windows_2016 - v2018.08.15