---
layout: post
title: A Custom UI For Running Local AI Models
date: 2026-03-03 17:27 +0000
categories: [Exploration]
tags: [linux, AI, ollama]
description: I couldn't find one for my needs, so I built my own. 
toc: true
media_subpath: /assets/post/a-custom-ui-for-running-local-ai-models/
image: cover.png
pin: false
mermaid: false
math: false
---

I like keeping things locally on my machine and that includes my use of AI.
Thankfully, there is ollama which provides opensource AI models to be run locally.
You can check out the website: [ollama.com](https://ollama.com).

## Available Options

- **openwebui:** It is okay. Similar UI to ChatGPT, but too heavy.

> I tried other ones, but I forgot their names :).
>
> I started the research early
> February. It's almost been a month. I remember openwebui because that was what
> came close to what I wanted.

## My Solution

I wanted simple features:

1. A chat interface with context.
2. File upload in chat.
3. Local database searchable by AI.
4. Chat history to continue past conversations.
5. Use any model to continue the conversation.

## Tools

I wanted to keep it simple and use existing building blocks. I also did not want
to make things heavy like openwebui. A good balance informed the choices:

- **streamlit:** For web ui.
- **sqlite:** For persistent local storage.
- **ollama:** For working with local AI models.
- **chroma_db:** For vector search to feed into AI model context.
- **pymupdf4llm:** To parse text from pdfs for llms.

Source code: [codeberg.org/davesaah/lui](https://codeberg.org/davesaah/lui)

## Screenshots

![Welcome Page](home-screenshot.png)
_Welcome Page_

You will notice a checkbox at the sidebar: **Use entire knowledge database**.
It allows you to add all saved local data as context. It is similar to ChatGPT's
memories.

![Model Options](model-opts-screenshot.png)
_Model Options_

![Local Knowledge Context](rag-screenshot.png)
_Local Knowledge Context_

![Chat With File - Phase 1](file-upload-screenshot.png)
_Chat With File - Phase 1_

![Chat With File - Phase 2](with-notifying-screenshot.png)
_Chat With File - Phase 2_

![Chat With File - Phase 3](chat-with-file-screenshot.png)
_Chat With File - Phase 3_

![Chat History](chat-history-screenshot.png)
_Chat History_

![Local Knowledge Context](local-rag-screenshot.png)
_Local Knowledge Context_

## Conclusion

It was a fun project. It took me 3 weeks to explore existing projects and create
the one perfect for my use case. It was worth the time. Now, I can ask my AI
anything without having to think about my data being shared with 3rd parties.
As always, doing my job as a linux community member and reinventing the wheel.
See you in the next one. Take care.
