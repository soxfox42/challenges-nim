import std/options
import std/sequtils
import std/sugar

type
  Board* = array[7, array[6, Player]]
  Player* = enum
    pNone, p1, p2

proc checkWin*(board: Board): (Player, seq[(int, int)]) =
  for x in 0..6:
    for y in 0..5:
      let first = board[x][y]
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
        if line.all(c => board[c[0]][c[1]] == first):
          return (first, line)

proc swapPlayer*(player: Player): Player =
  return case player:
    of pNone: raise newException(ValueError, "Can't swap player pNone")
    of p1: p2
    of p2: p1

# This is kind of a hacky score function.
proc score(board: Board): int =
  for x in 0..6:
    for y in 0..5:
      let lines = [
        (0..3).toSeq().map(i => (x + i, y)),
        (0..3).toSeq().map(i => (x, y + i)),
        (0..3).toSeq().map(i => (x + i, y + i)),
        (0..3).toSeq().map(i => (x + i, y - i)),
      ]
      for line in lines:
        if line.any(c => c[0] < 0 or c[0] > 6 or c[1] < 0 or c[1] > 5):
          continue

        # Count each player in line
        var
          p1_count = 0
          p2_count = 0
        for (x, y) in line:
          case board[x][y]:
          of p1: p1_count += 1
          of p2: p2_count += 1
          else: discard

        # Score lines that only contain one player's tokens
        if p1_count == 0:
          case p2_count:
          of 2: result += 1
          of 3: result += 10
          else: discard
        if p2_count == 0:
          case p1_count:
          of 2: result -= 1
          of 3: result -= 10
          else: discard

proc move*(board: Board, column: int, player: Player): Option[Board] =
  let index = board[column].find(pNone)
  if index == -1:
    return
  var newBoard = board
  newBoard[column][index] = player
  return some(newBoard)

proc minimax(board: Board, depth: int, a: int, b: int, maximize: bool): int =
  var
    a = a
    b = b
  let winner = board.checkWin()[0]
  if winner == p1:
    return -1000000
  elif winner == p2:
    return 1000000
  if depth == 0:
    return score(board)
  if maximize:  
    result = low(int)
    for i in 0..6:
      let moved = board.move(i, p2)
      if moved.isNone(): continue
      result = max(result, minimax(moved.get(), depth - 1, a, b, false))
      if result >= b: break
      a = max(a, result)
  else:
    result = high(int)
    for i in 0..6:
      let moved = board.move(i, p1)
      if moved.isNone(): continue
      result = min(result, minimax(moved.get(), depth - 1, a, b, true))
      if result <= a: break
      b = min(b, result)

# For simplicity this assumes the AI is always p2
proc bestMove*(board: Board): int =
  var maxValue = low(int)
  for i in 0..6:
    let moved = board.move(i, p2)
    if moved.isNone(): continue
    let value = minimax(moved.get(), 3, low(int), high(int), false)
    if value > maxValue:
      maxValue = value
      result = i
