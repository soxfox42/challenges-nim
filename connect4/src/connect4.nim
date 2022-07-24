import ai
import illwill
import std/enumerate
import std/options

type
  GameState = enum
    stStart, stPlay, stEnd
  Game = object
    state: GameState
    players: int
    tb: TerminalBuffer
    board: Board
    column: int
    curPlayer: Player

proc initGame(): Game =
  return Game(
    tb: newTerminalBuffer(terminalWidth(), terminalHeight()),
    players: 1,
    column: 0,
    curPlayer: p1,
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
  tb.setBackgroundColor(if game.curPlayer == p1: bgRed else: bgYellow)
  tb.write(0, 9, " ")
  tb.setBackgroundColor(bgNone)
  tb.write(1, 9, "'s turn.")
  tb.display()

proc drawWin(tb: var TerminalBuffer, player: Player, wins: seq[(int, int)]) =
  tb.setBackgroundColor(if player == p1: bgRed else: bgYellow)
  for cell in wins:
    tb.write(cell[0] + 1, 7 - cell[1], "X")
  tb.write(0, 9, " ")
  tb.setBackgroundColor(bgNone)
  tb.write(1, 9, " wins!  ") # Extra space to clear turn message.
  tb.write(0, 10, "Play again? (y/n)")

proc drop(game: var Game) =
  let moved = game.board.move(game.column, game.curPlayer)
  if moved.isNone():
    return
  game.board = moved.get()
  let win = game.board.checkWin()
  if win[0] != pNone:
    game.draw()
    drawWin(game.tb, win[0], win[1])
    game.tb.display()
    game.state = stEnd
    return
  if game.players == 1:
    game.board = game.board.move(bestMove(game.board), p2).get()
    let win = game.board.checkWin()
    if win[0] != pNone:
      game.draw()
      drawWin(game.tb, win[0], win[1])
      game.tb.display()
      game.state = stEnd
  else:
    game.curPlayer = swapPlayer(game.curPlayer)
  

illwillInit()
hideCursor()

var game = initGame()

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
    else: discard
  of stEnd:
    case key:
    of Key.Y: game = initGame()
    of Key.N: break
    else: discard

showCursor()
illwillDeinit()
