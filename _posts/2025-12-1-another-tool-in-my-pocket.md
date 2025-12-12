---
layout: post
title: Another Tool In My Pocket
date: 2025-12-1 08:55 +0000
categories: [Tools]
tags: [android, api, testing]
description: Discovered a tool for testing APIs on Android
media_subpath: /assets/post/another-tool-in-my-pocket/
toc: true
image: cover.jpeg
---

This is not going to be a long article or guide. I wanted to share a tool I 
started to use on my android device for API testing. One challenge I faced was 
the parsing of cookies. I am using json web tokens and storing them securely in
a cookie, but the problem was finding something native to use on my android 
device. I tried a couple options before settling on the one that satisfied my needs.

## Postman

I did not even look the way of postman web UI, I already had a bad experience 
of page loads and memory consumption. I did not even check to see if it resolves
my issue.

## Restfox

I liked restfox because it works offline and its a simple web interface and it's
compatible with postman it seemed a fine alternative. But there are limitations.
It seems to want a specific kind of http response. I cannot make http requests 
of all types, it only works well when it `text/json`. I don't want limitations 
because I like to explore different ways of doing things. I had to let it go.

## Honourable Mentions

- **hoppscotch:** It is great tool, but it doesn't allow the use of cookies 
  seemlessly when testing your API. I'm speaking of the web version.
- **Insomnia:** Insomnia is great tool. When I had a laptop, that was what I used
  for testing my APIs. Unfortunately, it doesn't have a web UI.

## What I Discovered - Reqable
What I love about reqable:

- It works offline.
- Has a native app.
- Nice on memory. Snappy and responsive.
- Auto management of cookies. It sets the cookies automatically and sends them
  on any request after that.
- It has collaboration mode. One collection, many users at the same time.
- It has history tracking, web app traffic monitoring. Yeah, I'm liking my new 
  tool in the toolbox.
- It has metrics to checkout the latency of API responses with different sections.
- It has a certificate manager.

And there's more.

All of this for 67 MB of storage after install. It's a good bargain if you'd ask me.

## Some Screenshots

![API Response Screenshot](api-response-screenshot.png)
_API Response Screenshot_

![Sidebar Menu Screenshot](sidebar-menu-screenshot.png)
_Sidebar Menu Screenshot_

![Metrics Screenshot](metrics-screenshot.png)
_Metrics Screenshot_

![Certificate Manager Screenshot](cert-manager-screenshot.png)
_Certificate Manager Screenshot_

## Concluding Words

Reqable offered more than I wanted, and all the other features are useful to me 
as well. Anyone wanting to test their APIs on their android device, checkout 
[reqable](https://reqable.com/en-US/).

I'm not sponsored by them. I'm a simple guy. Build a good tool to solve my problem,
I like, I support, I increase awareness, everybody happy.
