# challenges-nim
Swinburne Comp Sci/IT programming challenge, with the theme "Short n' sweet, learn a new language!"

When I started this challenge, I wrote this in a README:

> I happened to already be learning [Zig](https://ziglang.org/) at the time the challenge was announced, so I'm taking it as a good set of projects to learn with.

And then along came the macOS 13 Public Beta, which broke absolutely nothing... except Zig (and my name, but that's another story.)

```
thread 3486241 panic: Darwin is handled separately via std.zig.system.darwin module
Unable to dump stack trace: debug info stripped
```

What? What does that error even mean?

Anyway, time for take 2.

## Running
Make sure you have Nim 1.6.6 (or higher) installed, then:
```
cd [challenge_dir]
nimble run
```

## Challenges

1. [Fizz Buzz](fizz_buzz)
2. [File I/O](file_io)
3. [Text Parsing](text_parsing)
4. [Text Manipulation](text_manipulation)

## Aside: Languages
Why did I pick two relatively obscure languages? It's quite simple really. I wanted to properly stick to the rule that I had to use a language I hadn't used before. Unfortunately, I've used a lot of languages, though only a small selection make up 98% percent of the programming I do. I just like learning new programming languages. That really narrows down the available languages, but I picked some compiled languages that looked interesting to me.
