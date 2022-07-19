import std/json # parseJson + types
import std/os # paramCount, paramStr
import std/strformat # & operator

if paramCount() < 1:
  quit &"Usage: file_io [file]"

let fileName = paramStr(1)
let parsed = parseJson(readFile(fileName))
let people = parsed["people"]
for name, data in people.pairs():
  echo name & ": " & data["Home"].getStr()

people.add("Jason", %* {"Name": "Jason", "Age": 21, "Home": "San Fransico"})
writeFile(fileName, parsed.pretty())
