---
title: Reading Dell Optiplex 3070, 5070, 7070 fan speed in Linux
description: How to access the fan speed of some Dell Optiplex machines with lm-sensors on Linux
date: 2023-05-11T09:23:57.768Z
draft: false
tags:
  - dell
  - linux
  - sensors
keywords:
  - dell
  - Optiplex
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
featuredImage: images/header.png
lastmod: 2023-05-11T10:04:41.786Z
---

{{< toc >}}

{{< notice tip >}}
It's quite likely this could also work with similar devices, for example the Optiplex 5050, 5060, and so on (incl. variations such as 30*x*0, 70*x*0), but I cannot personally confirm this.  
Attempt at your own risk.
{{< /notice >}}

# Preamble

I recently bought myself a Dell Optiplex 5070 Micro to play with. It's the first node of what will be a 3-node cluster that I will use to start playing with Kubernetes in the real (read: non-virtualised) world.

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

To always load the driver at boot time, add `i8k force=1` to `/etc/modules` and reboot to see the change.  
You can do this simply like so: `echo 'i8k force=1' | sudo tee -a /etc/modules`

You will now be able to view the fan speed with `sensors`.

# Another useful tool

During my searches, I also found [i8kutils](https://github.com/vitorafsr/i8kutils), a package containing some utilities for controlling fans accessible by the i8k[^2] driver.

I haven't tested this on my Optiplex 5070 Micro, but thought it worth sharing nevertheless.

There are some open issues in the i8kutils repository noting some bugs with the Optiplex 5050, suggesting it at least partially works with this machine and others similar, and I've seen reports in various places of success with the Optiplex 7060.

[^1]: https://askubuntu.com/questions/1458266/how-can-i-view-the-cpu-fan-speed-on-a-dell-optiplex-3070
[^2]: https://github.com/lochotzke/i8k
