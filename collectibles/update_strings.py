# Author: https://github.com/Fernando-A-Rocha
# 
# Updates JSON file with all strings used by the Lua scripts
# Finds all .lua files in the current directory
#
# Usage: python update_strings.py
#

WORKING_DIRS = [".", "editor"]
JSON_FILE = "strings.json"
GCT_FUNC = "gct"

import os
import json

# Required: pip install luaparser
# https://github.com/boolangery/py-lua-parser
from luaparser import ast

def get_strings_from_file(file_path):
    with open(file_path, "r") as f:
        tree = ast.parse(f.read())
        strings = []
        # find calls to function GCT_FUNC
        for node in ast.walk(tree):
            if isinstance(node, ast.Call):
                if isinstance(node.func, ast.Name) and node.func.id == GCT_FUNC:
                    # get the first argument of the call
                    if isinstance(node.args[0], ast.String):
                        strings.append(node.args[0].s)
        return strings

def get_strings_from_dir(dir_path):
    strings = []
    for file in os.listdir(dir_path):
        if file.endswith(".lua"):
            file_path = os.path.join(dir_path, file)
            strings.extend(get_strings_from_file(file_path))
    return strings

print("Searching for strings used by " + GCT_FUNC + " in " + str(WORKING_DIRS))

strings = []
for dir in WORKING_DIRS:
    strings.extend(get_strings_from_dir(dir))
strings = { s: { "value": s, "rgb": [255, 255, 255] } for s in strings }

# update JSON file

with open(JSON_FILE, "w") as f:
    json.dump(strings, f, indent=4)

print("Updated " + JSON_FILE + " with " + str(len(strings)) + " strings")