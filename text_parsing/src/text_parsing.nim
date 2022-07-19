import std/strformat # unary & operator
import std/strutils # parseInt
import std/times # DateTime

type Payment = object
  date: DateTime
  value: int

proc parsePayment(str: string): Payment =
  if len(str) != 16:
    var e: ref ValueError
    new(e)
    e.msg = "invalid length"
    raise e
  let date = str[0..7].parse("yyyyMMdd")
  let value = str[8..15].parseInt()
  return Payment(date: date, value: value)

proc `$`(payment: Payment): string =
  let dollars = payment.value div 100
  let cents = payment.value mod 100
  let date = payment.date.format("dd/MM/yyyy")
  return &"${dollars}.{cents:02} due on {date}"

while true:
  stdout.write "Enter a payment string (YYYYMMDDCCCCCCCC, q to quit): "
  stdout.flushFile()
  let payment = readLine(stdin)

  if payment == "q":
    quit()
  
  try:
    echo payment.parsePayment()
  except [ValueError, IndexDefect]:
    echo "Invalid payment format."
