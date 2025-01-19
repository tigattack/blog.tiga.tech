+++
draft = false
date = 2018-01-06T15:47:33+00:00
title = "Discord notifications: Sonarr, Radarr and Lidarr"
description = "This is made extremely simple thanks to Sonarr's built-in support for Slack notifications and Discord's built-in support for Slack webhooks.  Of course Radarr and Lidarr support this too, as they are forks of Sonarr."
slug = "discord-notifications-for-sonarr-radarr-and-lidarr"
aliases = ["/discord-notifications-for-sonarr-radarr-and-lidarr"]
authors = ["tigattack"]
tags = []
categories = ["technology"]
series = ["Discord Notifications"]
+++

Part 1 of a Discord Notifications series.

I've had this running for a while and it works flawlessly, I'm very pleased with it.  
After having a few people ask me how it's done I decided it'd be best to make a post.

This is made extremely simple thanks to [Sonarr](https://github.com/Sonarr/Sonarr/)'s built-in support for Slack notifications and [Discord](https://discord.com/)'s built-in <a href="https://discord.com/developers/docs/resources/webhook#execute-slackcompatible-webhook" data-proofer-ignore>support for Slack webhooks</a>.
Of course [Radarr](https://github.com/Radarr/Radarr/) and [Lidarr](https://github.com/lidarr/Lidarr/) support this too, as they are forks of Sonarr.

I'll show you how to do this in Sonarr, but Radarr is identical and Lidarr is very similar, so you can follow this same process for each *arr.

---

Go to Discord and open the settings of the channel that you want Sonarr to report to. I created a channel called "downloads" just for these services.

{{< img src="a5606eefbd8f94ce.png" alt="Channel-edit" class="grid-w30" watermark=false >}}

Click "Create Webhook", and you'll see something similar to the following:

{{< img src="379acdfd293ce1f0.png" alt="Config-webhook" class="grid-w55" watermark=false >}}

As you can see mine has already been configured, but all you need to do is set the name, upload an image if you'd like (icons are at the bottom of this post) and then copy the webhook URL.

Now move over to Sonarr and navigate to Settings > Connect > Add > Slack.

Add a name for the connection. This isn't reflected in the notifications, so choose whatever you want.

Choose the type of notifications, and any series filters you want.

Now paste the webhook URL you copied earlier into the appropriate field in Sonarr, then go to the end of the URL and append `/slack`. This tells Discord to interpret the webhook as Slack would.

Type the webhook name in the username field and leave the last two empty.

Here's my configuration for reference:

{{< img src="df11f44f88de21b2.png" alt="Sonarr config" watermark=false >}}

Click "Test", then look back in Discord. You should see something like this:

{{< img src="404074dbdee3c666.png" alt="Sonarr-success" class="grid-w55" watermark=false >}}

Success!

Note: This method can be used for anything that supports Slack but not Discord, it's not limited to Sonarr and it's forks.

Icons:

* [Sonarr](https://avatars3.githubusercontent.com/u/1082903)
* [Radarr](https://avatars1.githubusercontent.com/u/25025331)
* [Lidarr](https://avatars1.githubusercontent.com/u/28475832)

These are the icons used by each project on their GitHub page.

---

I always welcome feedback on my posts, please [contact me](/contact) if you have any. I'm also happy to answer any related questions if I know the answer.
