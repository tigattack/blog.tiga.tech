+++
draft = true
date = 2018-11-02T00:00:00+01:00
title = "Running ElsaWin on ESXi"
description = "In this post, we'll learn how to convert a VirtualBox distribution of ElsaWin to run on ESXi."
slug = "elsawin-esxi"
authors = ["tigattack"]
tags = ["elsawin", "virtualbox", "vmware", "esxi"]
categories = ["technology", "automotive"]
series = []
+++

I'm running ESXi 6.5 but this shouldn't be much different for other versions

# export appliance from vbox

# convert ova to ovf with ovftool

```shell
ovftool --lax "\automotive01\c$\Users\user\Downloads\Elsawin 5.3\elsawin.ova" "\automotive01\c$\Users\user\Downloads\Elsawin 5.3\elsawin.ovf"
```

# modify ovf file

* On line 29, change `virtualbox-2.2` to `vmx-07`
* Change lines 48 - 53 to:
```xml
    <rasd:Caption>SCSIController</rasd:Caption>
    <rasd:Description>SCSI Controller</rasd:Description>
	    <rasd:ElementName>SCSIController</rasd:ElementName>
    <rasd:InstanceID>3</rasd:InstanceID>
    <rasd:ResourceSubType>lsilogic</rasd:ResourceSubType>
    <rasd:ResourceType>6</rasd:ResourceType>
```
* Change line 62 to `<Item ovf:required="false">`
* Remove lines 70-95 and replace with:
```xml
  <Item>
    <rasd:AddressOnParent>0</rasd:AddressOnParent>
    <rasd:Caption>disk1</rasd:Caption>
    <rasd:Description>Disk Image</rasd:Description>
    <rasd:HostResource>/disk/vmdisk1</rasd:HostResource>
    <rasd:InstanceID>6</rasd:InstanceID>
    <rasd:Parent>3</rasd:Parent>
    <rasd:ResourceType>17</rasd:ResourceType>
  </Item>
  <Item>
    <rasd:AutomaticAllocation>true</rasd:AutomaticAllocation>
    <rasd:Caption>Ethernet adapter on &apos;NAT&apos;</rasd:Caption>
    <rasd:Connection>NAT</rasd:Connection>
    <rasd:InstanceID>8</rasd:InstanceID>
    <rasd:ResourceSubType>E1000</rasd:ResourceSubType>
    <rasd:ResourceType>10</rasd:ResourceType>
  </Item>
```

Since we changed `myvm.ovf` the checksum will fail. Delete the myvm.mf will stop this being checked.

# export to host

```shell
ovftool -ds=<Datastore> -n="<VM Name>" --net:"NAT=<vSwitch Name>" "\Automotive01\C$\Users\user\Downloads\Elsawin 5.3\elsawin.ovf" vi://user@10.50.0.10/?ip=10.50.0.11
```

# change e1000 to vm net
