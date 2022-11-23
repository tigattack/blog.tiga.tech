+++
draft = true
date = 2021-04-12T00:00:00+01:00
title = "Home Assistant Configuration - CI and Automated Deployments"
description = "CI/CD for your Home Assistant configuration."
slug = "automate-your-home-assistant-configuration"
authors = ["tigattack"]
tags = ["home assistant", "hass", "ci/cd", "automation"]
categories = ["technology"]
series = []
+++

A.k.a. CI/CD for your Home Assistant configuration.

{{< toc >}}

# Introduction

I've been experimenting with various [CI/CD](https://www.redhat.com/en/topics/devops/what-is-ci-cd) solutions lately.

One such solution is [GitHub Actions](https://github.com/features/actions). Actions is free for up to 2000 minutes' runtime, making it applicable for pretty much any small-medium scale personal use cases. It's also incredibly easy to configure and can be very powerful.
At this point, I'm finding myself looking for any excuse to use them!

One such use-case I discovered is a workflow to entirely automate the validatation and deployment of my Home Assistant (HASS) configuration from GitHub.

In this post, I will run through the full process of getting this set up.

I'll be making some assumptions here, but I'll include short notes for each in case they're not fulfilled.

1. You already have your HASS configuration pushed to a GitHub repository (private or public, doesn't matter).
	If you don't, that's fine. Follow **steps 1-5** of [this great walkthrough](https://community.home-assistant.io/t/sharing-your-configuration-on-github/195144) on the Home Assistant forum.
2. You are running a Supervised install or HassOS. These both include the git binary, which we will need.
    If you're not running one of these deployments types, I suggest you do. They both come with a number of great additions over the various other deployment types.
4. You want GitHub to be the main point of control for your Home Assistant configuration.
	This Action will deploy your configuration from GitHub to HASS, therefore, GitHub must be the main point of control for your configuration - That is to say, to take full advantage of this, you must make changes to your configuration in GitHub rather than in HASS.
	If you don't want to do that, that's also fine. You can still follow this walkthrough and simply omit the CD part (deployment).

# CI - GitHub Actions

