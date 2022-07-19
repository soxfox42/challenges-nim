import json
import os
import strformat

if paramCount() < 1:
  quit &"Usage: file_io [file]"

let fileName = paramStr(1)
let parsed = parseJson(readFile(fileName))
let people = parsed["people"]
for key, value in people.pairs:
  echo key, value