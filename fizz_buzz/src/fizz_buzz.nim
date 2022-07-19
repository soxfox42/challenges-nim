import strutils # parseInt

# Use stdout rather than echo to avoid newline
stdout.write "Enter maximum value: "
stdout.flush_file()
let maxValue = stdin.readLine().parseInt()

proc fizzbuzz(n: int): string =
  if n mod 3 == 0 and n mod 5 == 0:
    return "Fizzbuzz!"
  elif n mod 3 == 0:
    return "Fizz"
  elif n mod 5 == 0:
    return "Buzz"
  else:
    return $n

for num in 1..maxValue:
  echo fizzbuzz(num)