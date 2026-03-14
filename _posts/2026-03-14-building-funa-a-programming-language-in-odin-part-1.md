---
layout: post
title: 'Building Funa: A Programming Language in Odin - Part 1'
date: 2026-03-14 14:27 +0000
categories: [Exploration]
tags: [odin, programming-languages, memory-management, compilers]
description: I am building a programming language. Here is what has happened so far.
toc: true
media_subpath: /assets/post/building-funa-a-programming-language-in-odin-part-1
image: cover.jpg
pin: false
mermaid: false
math: false
---

I am building a [programming language](https://en.wikipedia.org/wiki/Programming_language)
and I want to document the process. I
realised there is little to show for completeness. Right? Many see and they are
like: okay? and shrug off not knowing the work that went into it. Am I doing this
for others? Yes and no. Yes because, I want people to see that the skills I have
or not just on paper, but real. Secondly, someone somewhere might be inspired.
No because, even if no one reads my articles, I will still write for myself. It
is my way of reflecting and learning.

I'm leaving the old way of showing the finished goods and tell of the process.
Though I'm five days late, it is better than later. I'll be sharing what I've been
up to in this project: things that worked, things that failed, my lessons and most
importantly, the why behind my decision-making.

I called this project `funa` because it is the short form of the idea: **Fun**ctional
**A**utomation.

## Why Funa?

Funa is a [functional programming](https://en.wikipedia.org/wiki/Functional_programming)
language for shell automation. The idea is that
you write your code and it runs [GNU Core Utilities](https://en.wikipedia.org/wiki/GNU_Core_Utilities) 
to do the execution. 

Here is what Funa looks like right now:

```
let some = 5;
let name = "sam";

function do_something() {
    someone = 34;
}

function findByHoursModified(filename :string, hours :int) {
    someone = 34;
}
```

We have [tokenization](https://en.wikipedia.org/wiki/Lexical_analysis#Tokenization)
working properly. I might remove the semicolons for termination
sometime later. I'll keep them for now. And for the nerds out there, we have 
something called a language grammar which is presented in 
[Backus Naur Form](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form).
I am taking it one at a time and this is the current BNF for the language.

```
* means 0 or many
? means 0 or 1

<program> ::= <statement>*

<statement> ::= <let-bind>
              | <fn-def>

<let-bind> ::= LET IDENT ASSIGNMENT <expr>

<expr> ::= NUMBER | STRING

<fn-def> ::= FUNCTION IDENT LPAREN <param-list>? RPAREN COLON <type> <block>

<param-list> ::= <param> ( COMMA <param> )*
<param> ::= IDENT COLON <type>

<block> ::= LBRACE <statement>* <return-stmt> RBRACE

<return-stmt> ::= RETURN <expr>

<type> ::= "integer" | "string" | "float"
```

I am building this language in [Odin](https://odin-lang.org/).

## Why Odin?

I wanted to learn a language with manual memory management and picked Odin. I 
chose it because it is a modern systems language. Nothing wrong with C, C++ or 
Rust. The language does 3 things for me:

1. The syntax is close to [Go](https://go.dev/), which is my primary language. 
  Getting up to speed is not an issue.
2. Most of the quirks in C, C++ and Rust are addressed in Odin. It doesn't do a
  lot, yet gives you the tools to move. I like a simple system it doesn't tie me
  to a specific way.
3. It's memory model is an intersection of understanding the technicals of memory
  and allowing you to do whatever you want without much hustle.

I mean the above points can be considered subjective, but I know a good tool when
I see one. Odin is it. That is why I want to learn it. I remember back in 2020
reading about Go and deciding to master the language. It wasn't as popular as it
is today, but I was the potential. Today, it is all over the place. 

I'm not saying Odin will take off as Go did. What I'm saying is that it is worth
the investment today. Hardware is improving faster than software. It is about time
we cared about using the tools for the job, not the tools we know.

I'll stand on this hill: using javascript for everything is a mistake. Enough
talk, back to the context.

## Where Things Are

Five days in. The [lexer](https://en.wikipedia.org/wiki/Lexical_analysis) is working. It handles:

- Symbols: parentheses, braces, semicolons, assignment, etc.
- Keywords: `let`, `function`, `return`, etc.
- Data types: integers, floats, strings
- Identifiers

The token type system is a union over three enums:

```
TokenType :: union { Symbol, DataType, Keyword }
```

Keywords are resolved with a switch-based `lookup_identifier` to avoid implicit
allocations. String and character literal parsing is handled by a `read_string`
helper to avoid duplicating that logic.

During development, I use the tracking allocator to catch leaks and Odin's
built-in test runner to validate new features. For the harder bugs, 
[GDB](https://en.wikipedia.org/wiki/GNU_Debugger) with debug symbols (`odin build . -debug`).

## What Happened Today

I ran into memory issues and I want to walk you through each one.

### The Setup

The lexer reads a file line by line and tokenises each line. All the tokens need
to be collected into one array for the parser. Here is what it looks like:

```
run_lexer :: proc(s: string) -> [dynamic]token.Token {
    l := lexer.new(s)
    tokens := make([dynamic]token.Token)

    for tok := lexer.get_next_token(&l);
        tok.type != token.Symbol.EOF;
        tok = lexer.get_next_token(&l) {
        append(&tokens, tok)
    }

    return tokens
}
```

### Garbage Values

The first thing I saw was something like this:

```
Token{literal = "\x1dN\x87\xa5", type = "STRING"}
Token{literal = "\x0e\n\x1d",    type = "INTEGER"}
```

I learnt that in Odin, `string` is just a `{ptr, len}` pair. It does not own the
memory it points to. The lexer was storing slices directly into the input line. 
When that line went away, the token literals were pointing at garbage. I'm accessing
data in a memory location in which the data has been freed. Not good.

### Attempted Fix: strings.clone

One thing I know about memory is the concept of heap and stack. The idea of cloning
came from using [`rust`](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html)
a few years back. I decided to clone the memory so that
the lifetime extends beyonds the scope by creating a new allocation for it in a
larger scope.

This is how I went about it in Odin:

```
tok.literal = strings.clone(tok.literal)
append(&tokens, tok)
```

That fixed the garbage values. But now every token literal was a heap allocation
I had to free manually:

```
defer {
    for tok in tokens do delete(tok.literal)
    delete(tokens)
}
```

Not great for a programming language where parsing source code is one of the core
features.

### The Fix: Context Allocator and Dynamic Arena

I went to revise the notes I made earlier on types of memory management in Odin.
Let me give you a brief about them:

- **heap_allocator:** general purpose, default.
- **arena_allocator:** many short-lived allocs, free all at once.
- **temp_allocator:** scratch allocator meant to be reset periodically.
- **tracking_allocator:** debugging; detects leaks and double-frees.

The way to use these allocators is to update the context allocator. Like the name,
it is the allocator being used in the current context/scope. 

I decided to use an arena allocator in the context where I call the function.
Any memory created in the scope of the context allocator will be inside the 
'arena'. To clean things up, I free only the allocator.

Translating that into code:

```
arena: mem.Dynamic_Arena
mem.dynamic_arena_init(&arena)
defer mem.dynamic_arena_destroy(&arena)
context.allocator = mem.dynamic_arena_allocator(&arena)

tokens := make([dynamic]token.Token)

for {
    line, read_err := bufio.reader_read_string(&reader, '\n')
    // arena-owned, no cleanup needed

    line_tokens := run_lexer(line)
    append(&tokens, ..line_tokens[:])
}
```

I do not need to change the implementation of the lexer. No `strings.clone` is
needed in the `run_lexer` procedure because the line strings are already in the
arena and stay valid for as long as the arena is alive:

```
run_lexer :: proc(s: string) -> [dynamic]token.Token {
    l := lexer.new(s)
    tokens := make([dynamic]token.Token)

    for tok := lexer.get_next_token(&l);
        tok.type != token.Symbol.EOF;
        tok = lexer.get_next_token(&l) {
        append(&tokens, tok)
    }

    return tokens
}
```

### Why This Works (Technical Correctness)

The arena holds one contiguous block of memory. Every allocation bumps a pointer
forward:

```
[ arena backing buffer                              ]
  ^tokens  ^line1  ^literal1  ^literal2  ^line2  ...
```

When `mem.dynamic_arena_destroy` is called via `defer`, the whole block is freed
at once. No looping over tokens. No per-literal `delete`. Everything has the same
lifetime, the arena owns it all.

> Read more on memory allocation strategies from 
> [Ginger Bill's series](https://www.gingerbill.org/series/memory-allocation-strategies/)

## Output

The lexer now correctly tokenises a Funa source file:

from:

```
"Hello World"
'some'
233
23.3
let some = 5;
function app() {
	someone = 34;
}
```

to:

```
Token{literal = "Hello World", type = "STRING"}
Token{literal = "233",         type = "INTEGER"}
Token{literal = "23.3",        type = "FLOAT"}
Token{literal = "let",         type = "LET"}
Token{literal = "some",        type = "IDENTIFIER"}
Token{literal = "=",           type = "ASSIGNMENT"}
Token{literal = "5",           type = "INTEGER"}
Token{literal = ";",           type = "SEMI_COLON"}
Token{literal = "function",    type = "FUNCTION"}
Token{literal = "app",         type = "IDENTIFIER"}
Token{literal = "(",           type = "LPAREN"}
Token{literal = ")",           type = "RPAREN"}
Token{literal = "{",           type = "LCURLY"}
Token{literal = "someone",     type = "IDENTIFIER"}
Token{literal = "=",           type = "ASSIGNMENT"}
Token{literal = "34",          type = "INTEGER"}
Token{literal = ";",           type = "SEMI_COLON"}
Token{literal = "}",           type = "RCURLY"}
```

## What I Learned

- **Strings in Odin are just pointers.** They don't own their memory.
  If what they point to goes away, you get garbage.
- **Arenas are the right tool when allocations share a lifetime.** Simpler and
  harder to get wrong than per-item cleanup.
- **Odin's context allocator makes this composable.** Swap the allocator once,
  everything downstream follows. No changes needed in the functions that allocate.

## What's Next

Lexer is done. Next is the [parser](https://en.wikipedia.org/wiki/Parsing) to 
build an [Abstract Syntax Tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree)
from the token stream. I have already settled on using the
[recursive descent strategy](https://en.wikipedia.org/wiki/Recursive_descent_parser).
Along the way, I'll be expanding Funa's expression syntax.

Yeah, that's all for now. Take care.
