# Chocolatey Environments

Environments used to test and demonstrate Chocolatey features and benefits.

## Before Continuing!

The environments provided are for **temporary experimentation and testing purposes only**. They are not intended, nor should they be used, in a production environment! Many of the environment use default or other well known credentials.

## Prerequisites

To run these environments:

* Vagrant
* Virtualbox

There are a few things you need to do to setup your system to be able to run these environments:

### Business Editions (Chocolatey For Business, Architect and MSP)

If you are running a business edition of Chocolatey, perform the following steps:

1. Run `SetupCommonResources.ps1` from the root folder. This will download and internalize a selection of standard packages used for different environments:
    * If you want to force the redownload of the common packages, use the `-Force` parameter;
    * If you need or want to download the .NET 4 installer, please use the `-DownloadDotNet4` parameter;
1. Copy `chocolatey.extension.<VERSION>.nupkg` to the `packages` folder;
1. Copy your business license to the `licenses` folder and make sure it is called `chocolatey.license.xml`;

## Vagrant Images

We are using the following Vagrant images for our boxes:

* Windows Server 2016 - StefanScherer/windows_2016

## Standard Software

Unless specified otherwise each Vagrant server has the latest version of the following software installed:

* Chocolatey
* Baretail
* dotnetversiondetector
* Notepad++
* 7zip

# Troubleshooting

## Cannot connect / ping another Vagrant machine

This is a common issue and is related to Vagrant itself. If you run `vagrant reload` on the box that you cannot connect to or ping this will restart it. Afterwards you should be able to connect or ping it.
