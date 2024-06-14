+++
draft = false
date = 2019-10-28T15:25:20+00:00
title = "MacBook Pro Touch Bar — Fix stuck keys"
description = ""
slug = "macbook-pro-touchbar-fix-stuck-jammed-hung-keys"
aliases = ["/macbook-pro-touchbar-fix-stuck-jammed-hung-keys"]
authors = ["tigattack"]
tags = ["mac"]
categories = ["technology"]
series = []
+++

Those of you who rarely perform a full shutdown or reboot on your MacBook may occasionally encounter issues with the Touch Bar.

One such issue is stuck//frozen keys.

Unfortunately for me, my escape key happened to become stuck "on", persistently spamming the escape keycode to the foremost application.

This rendered many applications entirely useless, and stopped me even being able to access the Apple menu to perform power operations!

Thankfully, there is a fix for this:

1. Open Launchpad by pinching inwards on the touchpad with your thumb and three fingers.
2. Open Terminal.
3. Run `sudo killall ControlStrip && sudo pkill "Touch Bar Agent"`

Some of the keys on the Touch Bar will disappear for a moment while it restarts.

After this, it should be good as gold!

---

I always welcome feedback on my posts, please [contact me](/contact) if you have any. I'm also happy to answer any related questions if I know the answer.
