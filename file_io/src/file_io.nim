import std/json # parseJson + types
import std/os # paramCount, paramStr, fileExists
import std/strformat # unary & operator

# Check file existence
if paramCount() < 1:
  quit "Usage: file_io [file]"
let fileName = paramStr(1)
if not fileExists(fileName):
  quit &"File \"{fileName}\" not found."

# Parse JSON
let parsed = try:
  parseFile(fileName)
except IOError:
  quit "Error reading file."
except JsonParsingError as e:
  quit "Invalid JSON file:\n" & e.msg

# Access people object and print
let people = parsed{"people"}
if people == nil or people.kind != JObject:
  quit "Bad JSON format - missing people object."
for name, data in people.pairs():
  echo name & ": " & data["Home"].getStr()

# Insert new person and write
people.add("Jason", %* {"Name": "Jason", "Age": 21, "Home": "San Fransico"})
try:
  writeFile(fileName, parsed.pretty())
except IOError:
  quit "Error writing file."
