#CRM-QA

This repository contains pre-configured vagrant environments in which you can test packaged releases of ChurchCRM
Change your working directory into any of these folders, and run ```vagrant up``` to provision a new VM configured for the specified branch

No VMs run with shared storage, and therefore won't incur the VirtualBox latency penalty. 
Performance of the testing environment should be in line with a high-end hosting provider.

Additionally, no development dependencies are included in the testing environment, so this should more closely mirror what a hosting provdier would offer.

## Release

This will provision a Vagrant VM based on the code from the latest GitHub full release
IP: 192.168.33.20

## Master

This will provision a Vagrant VM based on the code in the latest commit to the Master Branch
IP: 192.168.33.21

## Develop

This will provision a Vagrant VM based on the code in the latest commit to the Develop Branch
IP: 192.168.33.22

## Expiremental

This will provision a Vagrant VM based on the code in the zip file placed in the directory
IP: 192.168.33.23

## ChurchInfo

This will provision a Vagrant VM based on ChurchInfo 1.2.14
IP: 192.168.33.24