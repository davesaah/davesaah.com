---
layout: post
title: 'Building Funa Pt.2: Parser Edge Cases'
date: 2026-03-23 17:35 +0000
categories: [Exploration]
tags: [odin, programming-languages, memory-management, compilers]
description: Dealing with parser edge cases
toc: false
media_subpath: /assets/post/building-funa-pt-2-parser-edge-cases
image: cover.jpg
pin: false
mermaid: false
math: false
---

Last week I continued work on the parser and decided to focus on finding a good
flow at the start. My plan is that when I establish a good flow with one part, 
the rest would be easier. I focused on the `<var-bind>` statement:

```
<program> ::= <statement>*

<statement> ::= <var-bind>
              | <fn-def>

<var-bind> ::= LET IDENT ASSIGNMENT <expr>

<expr> ::= NUMBER | STRING

<fn-def> ::= FUNCTION IDENT LPAREN <param-list>? RPAREN COLON <type> <block>

<param-list> ::= <param> ( COMMA <param> )*
<param> ::= IDENT COLON <type>

<block> ::= LBRACE <statement>* <return-stmt> RBRACE

<return-stmt> ::= RETURN <expr>

<type> ::= "integer" | "string" | "float"
```

What is a good flow? Well, the parser will translate the language grammar into 
a syntax tree. The grammar definition for the syntax of statements may be 
different, but the processes are similar. Here are two important consistencies
when building the tree:

1. Syntax error handling.
2. Token peeking for construction the Abstract Syntax Tree. Like a mini state 
  machine.

They were both simple to write, especially the second one. For the syntax error
handling, I had some edge cases. It is the classic off by one error. Let me give
you some context.

**Error on the last line on the last column**

Funa code:

```
let some = 4
let some = 2
let some = 1
let some =
```

Output:

```
Syntax Error on line 4, column 10: expected ["INTEGER", "FLOAT", "STRING"], got EOF
```

Comment:

Line 4 is correct. Column 10 is correct.

**Error in the middle**

Funa code:

```
let some = 4
let = 2
let some = 1
let some = 0
```

Output:

```
Syntax Error on line 2, column 5: expected ["IDENTIFIER"], got ASSIGNMENT
```

Comment:

Line 2 is correct. Column 5 is correct.

**Our so called edge case: error on first line, first column**

Funa code:

```
et some = 4
let some = 2
let some = 1
let some = 0
```

Output:

```
Syntax Error on line 1, column 4: expected ["LET", "FUNCTION"], got IDENTIFIER
```

Comment:

Line 1 is correct. Column 4, not so much. I was expecting it to point to column
one. It is consistent if the syntax error ends up being on the first column no
matter the line.

---

I had two thoughts:

1. Continue to spend time figuring out why that edge case exists.
2. Remove the column number tracker entirely.

I decided to leave it as it is and focus on the main things. It may not be a big 
deal as I make it out to be. If I eventually find out how to deal with it, or if
anyone figures it out, feel free to make a pull request on the 
[repo](https://github.com/davesaah/funa).

## Concluding Words

That was the progress made with regards to learning Odin and building **funa**.
I won't say I learnt anything syntax-wise to Odin. Its syntax is easier to 
grasp. I do enjoy the manual memmory management. It's not as scary as we make it.
