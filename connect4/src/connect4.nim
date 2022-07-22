import ai
import illwill
import std/enumerate
import std/sequtils
import std/sugar

type
  GameState = enum
    stStart, stPlay, stEnd
  Game = object
    state: GameState
    players: int
    tb: TerminalBuffer
    board: Board
    column: int
    cur_player: Player

proc newGame(): Game =
  return Game(
    tb: newTerminalBuffer(terminalWidth(), terminalHeight()),
    players: 1,
    column: 0,
    cur_player: p1,
  )

proc drawStartMenu(game: Game) =
  var tb = game.tb
  tb.clear()
  tb.write(0, 0, "Connect Four")

  if game.players == 1:
    tb.setStyle({styleReverse})
  tb.write(0, 2, "1 - Vs AI")
  tb.setStyle({})

  if game.players == 2:
    tb.setStyle({styleReverse})
  tb.write(0, 3, "2 - Vs Player")
  tb.setStyle({})

  tb.display()

proc draw(game: Game) =
  var tb = game.tb
  tb.clear()
  tb.fill(1, 0, 7, 0, " ")
  tb.write(game.column + 1, 0, "v")
  tb.drawRect(0, 1, 8, 8)
  for x, col in enumerate(game.board.items):
    for y, el in enumerate(col.items):
      case el:
      of pNone: tb.setBackgroundColor(bgNone)
      of p1: tb.setBackgroundColor(bgRed)
      of p2: tb.setBackgroundColor(bgYellow)
      tb.write(x + 1, 7 - y, if x == game.column: "." else: " ")
  tb.setBackgroundColor(if game.cur_player == p1: bgRed else: bgYellow)
  tb.write(0, 9, " ")
  tb.setBackgroundColor(bgNone)
  tb.write(1, 9, "'s turn.")
  tb.display()

proc checkWin(game: Game): (Player, seq[(int, int)]) =
  for x in 0..6:
    for y in 0..5:
      let first = game.board[x][y]
      if first == pNone:
        continue
      let lines = [
        (0..3).toSeq().map(i => (x + i, y)),
        (0..3).toSeq().map(i => (x, y + i)),
        (0..3).toSeq().map(i => (x + i, y + i)),
        (0..3).toSeq().map(i => (x + i, y - i)),
      ]
      for line in lines:
        if line.any(c => c[0] < 0 or c[0] > 6 or c[1] < 0 or c[1] > 5):
          continue
        if line.all(c => game.board[c[0]][c[1]] == first):
          return (first, line)

proc drawWin(tb: var TerminalBuffer, player: Player, wins: seq[(int, int)]) =
  tb.setBackgroundColor(if player == p1: bgRed else: bgYellow)
  for cell in wins:
    tb.write(cell[0] + 1, 7 - cell[1], "X")
  tb.write(0, 9, " ")
  tb.setBackgroundColor(bgNone)
  tb.write(1, 9, " wins!  ") # Extra space to clear turn message.
  tb.write(0, 10, "Play again? (y/n)")

proc drop(game: var Game) =
  var idx = game.board[game.column].find(pNone)
  if idx != -1:
    game.board[game.column][idx] = game.cur_player
    let win = game.checkWin()
    if win[0] != pNone:
      game.draw()
      drawWin(game.tb, win[0], win[1])
      game.tb.display()
      game.state = stEnd
      return
    if game.players == 1:
      discard # ai
    else:
      game.cur_player = if game.cur_player == p1: p2 else: p1

illwillInit()
hideCursor()

var game = newGame()

while true:
  let key = getKey()
  case game.state:
  of stStart:
    game.drawStartMenu()
    case key:
    of Key.Up, Key.One: game.players = 1
    of Key.Down, Key.Two: game.players = 2
    of Key.Enter: game.state = stPlay
    else: discard
  of stPlay:
    game.draw()
    case key:
    of Key.Left: game.column = max(0, game.column - 1)
    of Key.Right: game.column = min(6, game.column + 1)
    of Key.Enter: game.drop()
    of Key.Q: break
    else: discard
  of stEnd:
    case key:
    of Key.Y: game = newGame()
    of Key.N: break
    else: discard

showCursor()
illwillDeinit()
