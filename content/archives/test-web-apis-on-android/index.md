+++
date = '2025-12-01T09:58:46Z'
draft = false
title = 'Test Web APIs on Android'
lastmod = '2026-04-09T13:18:26Z'
tags = ["api", "android", "rest", "web", "testing"]
+++

After building web APIs on android, you have to test them. These are the findings after some research.

## Postman

Don't even look the way of postman web UI, bad experience of page loads and memory consumption.

## Restfox

Works offline and has a simple web interface. It's compatible with postman and makes a fine alternative. But there are limitations. It seems to want a specific kind of http response. You cannot make http requests of all types, it only works well when it's `text/json`. You don't want limitations so let this one go.

## Honourable Mentions

- **hoppscotch:** It is great tool, but the web version doesn't allow the use of cookies seemlessly when testing your API.
- **Insomnia:** Insomnia is great tool for laptops, but has no web UI to access on android.

## Suggested Choice: Reqable

Why?

- It works offline.
- Has a native android app.
- Nice on memory. Snappy and responsive.
- Auto management of cookies. It sets the cookies automatically and sends them with any request after that.
- It has collaboration mode. One collection, many users at the same time.
- It has history tracking.
- It has web app traffic monitoring.
- It has metrics to checkout the latency of API responses with different sections.
- It has a certificate manager.
- And there's more.
- All of this for 67 MB of storage after install.

It's a good bargain. Check out [reqable](https://reqable.com/en-US/).
