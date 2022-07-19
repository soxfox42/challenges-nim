import std/strutils # find, toLower

# Convert one word to Pig Latin.
proc pigLatinWord(word: string): string =
  let cutIndex = word.find({'a', 'e', 'i', 'o', 'u'})
  if cutIndex == -1:
    return word
  if cutIndex == 0:
    return word & "yay"
  return word[cutIndex..^1] & word[0..cutIndex - 1] & "ay"

# Iterate through input, using pigLatinWord on each group of word chars
proc pigLatin(input: string): string =
  let inputLower = input.toLower()
  var wordBuf = ""
  for ch in inputLower:
    if ch in 'a'..'z':
      wordBuf.add(ch)
    else:
      result.add(pigLatinWord(wordBuf))
      wordBuf = ""
      result.add(ch)
  result.add(pigLatinWord(wordBuf))

echo "EOF to exit (Ctrl-D on Unix, Ctrl-Z then Enter on Windows)"

# Main loop, just pass user lines to pigLatin
while not false:
  stdout.write "> "
  stdout.flushFile()

  try:
    echo pigLatin(stdin.readLine())
  except EOFError:
    # Handle EOF to exit cleanly
    break
