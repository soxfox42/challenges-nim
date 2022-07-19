import std/strutils # parseInt

# Get the maximum value, retrying on bad input.
var maxValue: int
while true:
  try:
    # Use stdout rather than echo to avoid newline
    stdout.write "Enter maximum value: "
    stdout.flush_file()
    maxValue = stdin.readLine().parseInt()
    break
  except ValueError:
    echo "Invalid number."

# Returns the line to be printed for a specific number.
proc fizzbuzz(n: int): string =
  if n mod 3 == 0 and n mod 5 == 0:
    return "Fizzbuzz!"
  elif n mod 3 == 0:
    return "Fizz"
  elif n mod 5 == 0:
    return "Buzz"
  else:
    return $n

# Loop through 1-max, printing fizzbuzz lines.
for num in 1..maxValue:
  echo fizzbuzz(num)
