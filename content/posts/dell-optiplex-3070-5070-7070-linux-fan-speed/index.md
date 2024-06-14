---
title: Reading Dell OptiPlex 3070, 5070, 7070 fan speed in Linux
description: How to access the fan speed of some Dell OptiPlex machines with lm-sensors on Linux
date: 2023-05-11T09:23:57.768Z
draft: false
tags:
  - dell
  - linux
  - sensors
keywords:
  - dell
  - OptiPlex
  - linux
  - sensors
  - lm-sensors
  - fan speed
  - fan RPM
categories:
  - technology
authors:
  - tigattack
series: {}
---

{{< alert "lightbulb" >}}
This is likely to work for other generations and classes of OptiPlex desktops (e.g. 3050, 5060, etc.), but I cannot personally confirm this. 
Attempt at your own risk.
{{< /alert >}}
<br>
# Preamble

I recently bought myself a Dell OptiPlex 5070 Micro to play with. It's the first node of what will be a 3-node cluster that I will use to start playing with Kubernetes in the real (read: non-virtualised) world.

During the initial setup, I realised I couldn't see the fan speed with the `sensors` utility from the `lm-sensors` Linux package.

After the usual `sudo sensors-detect` (I actually use `sudo sensors-detect --auto` because I like to live dangerously), I could see core temperatures and other sensor readings, but no fan speed.

Thanks to some great folks on Ask Ubuntu[^1], I found the solution to this was very simple.

To read fan speeds, the `i8k`[^2] kernel driver must be loaded. This driver provides access to the SMM BIOS, designed for Dell laptops, but it works with these machines too.

At first I tried `sudo modprobe i8k`, but received an error: `could not insert 'dell_smm_hwmon': No such device`

Oh well, hammer method it is I guess: `sudo modprobe i8k force=1`

And just like that, I can see fan speeds with `sensors`!

# Solution

You will, of course, need the `lm-sensors` package.

I also strongly suggest running `sudo sensors-detect`. The default choices from this utility can be safely accepted if you're unsure of anything.

For one-time usage, simply run this: `sudo modprobe i8k force=1`

If you wish to always load the driver at boot time, here's how:
  1. `echo 'i8k' | sudo tee -a /etc/modules`  
  By adding the line `i8k` to `/etc/modules`, we instruct the system to load the module at boot time.
  1. `echo 'options i8k force=1' | sudo tee -a /etc/modprobe.d/i8k.conf`  
  By adding the line `options i8k force=1` to `/etc/modprobe.d/i8k.conf`, we instruct the system which options to use when loading the module.  
  You can name this whatever you like as long as it has a `.conf` extension.
  1. Reboot to see the change.

You will now be able to view the fan speed with `sensors`.

# Another useful tool

During my searches, I also found [i8kutils](https://github.com/vitorafsr/i8kutils), a package containing some utilities for controlling fans accessible by the i8k[^2] driver.

I haven't tested this on my OptiPlex 5070 Micro, but thought it worth sharing nevertheless.

There are some open issues in the i8kutils repository noting some bugs with the OptiPlex 5050, suggesting it at least partially works with this machine and others similar, and I've seen reports in various places of success with the OptiPlex 7060.

[^1]: https://askubuntu.com/questions/1458266/how-can-i-view-the-cpu-fan-speed-on-a-dell-optiplex-3070
[^2]: https://github.com/lochotzke/i8k
