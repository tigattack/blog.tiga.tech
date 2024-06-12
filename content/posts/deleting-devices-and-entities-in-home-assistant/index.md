+++
draft = false
date = 2020-06-12T21:00:24+01:00
title = "Deleting Devices and Entities in Home Assistant"
description = "One of my major bugbears in Home Assistant has always been that there's no proper way to completely delete a device or entity.   However, that's not quite true..."
slug = "deleting-devices-and-entities-in-home-assistant"
aliases = ["/deleting-devices-and-entities-in-home-assistant"]
authors = ["tigattack"]
tags = ["hass", "home assistant"]
categories = ["technology"]
series = []
+++

One of my major bugbears in Home Assistant (HASS) has always been that some integrations offer no proper way to completely delete a device or entity.

It seems so odd to me that in some cases there is no functionality beyond "disable".

{{< alert "circle-info" >}}
It's been pointed out to me that this is only true for entities which are available. For those which are marked "unavailable", there is an option to delete. I will keep this up though because I'm sure it will still be useful for someone!
{{< /alert >}}

However, it's not *quite* true that there's no way to delete them... It is possible, but it can also go wrong.

Entities and devices are stored in configuration files in `/config/.storage/` (`core.device_registry` and `core.entity_registry` respectively). Depending on the type, they may also have an entry in `core.config_entries`.

Below is the process to entirely remove a device and/or entity in Home Assistant.

{{< alert >}}
I cannot take any responsibility if you break your HASS installation whilst following this, but if you carry out the backup process correctly, you should be fine.
{{< /alert >}}

---


# 1. Backup

Make sure you have a backup or snapshot of HASS from before you make these changes.

You can backup the entire machine it's running on, snapshot the VM (if it's on a VM), or take a snapshot in HASS's backups section in the settings.

# 2. Shutdown Home Assistant

In general it's not a good idea to modify these core files while HASS is running. Since they aren't *supposed* to be user-modifiable, HASS doesn't expect them to be changed by anything other than itself and therefore may not handle it nicely if they are changed while it's running.

{{< alert "circle-info" >}}
If you're running HassOS this may not be possible. I'm not familiar with the ins and outs of HassOS, having never used it myself. You could try editing these files while HASS is running and then restart it, but I can't guarantee that will work.
{{< /alert >}}


# 3. Modify the files

There are many ways to access HASS's config while it's not running, but the easiest way will be SSH in most cases.

1. SSH to your HASS machine and move to your config directory.  
  If you're running HASS in Docker, that will probably be `/usr/share/hassio/homeassistant/`.
2. Move to the `.storage` directory and edit the following files with your choice of text editor.
    * `core.device_registry`
    * `core.entity_registry`
    * `core.config_entries`
3. In each file, search for references to the name of the device or entity you want to remove.
4. Delete the entire section for that object.
5. Repeat steps 3 and 4 for each device or object you wish to remove from HASS.

**Make sure you keep the syntax correct!**

This is of the utmost importance. If you get this wrong, it *will* break.

If you're unsure, paste the entire file into [JSONLint](https://jsonlint.com/), which will validate JSON syntax for you.

# 4. Start Home Assistant

With all luck, HASS will start back up without a care in the world, just the way it shut down but without those pesky devices/entities you didn't want!

Once it's started, you should check the logs to ensure it's not found any new problems in your configuration.

If something's gone wrong and it doesn't start up or starts up with a lot of errors, I suggest restoring from the backup or snapshot you took earlier and trying again.

---

I always welcome feedback on my posts, please [contact me](/contact) if you have any. I'm also happy to answer any related questions if I know the answer.
