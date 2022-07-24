# Connect 4

> make a game of connect four. Simple.

\- Pdgeorge on the Comp Sci/IT server

k lol

The AI is kind of hard to beat, except when it sometimes makes really dumb moves.

## Notes
- Nim doesn't really consider methods as part of an object. The syntax `game.draw()` is just syntactic sugar for `draw(game)`, and the proc is defined as `proc draw(game: Game) =`.
- Nimble is Nim's standard package manager (though it wasn't always bundled with the langauge), and there seems to be a decent selection of libraries available for it.
- You can't modify a parameter passed to a proc in Nim, unless you mark it `var` which causes it to change externally as well. Because of that, there's a workaround in my a-b minimax, using `var a = a` to allow updating the alpha value.
