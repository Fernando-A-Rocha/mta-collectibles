# Author: https://github.com/Fernando-A-Rocha
# 
# Updates JSON file with all strings used by the Lua scripts
# Finds all .lua files in the current directory
# Run this script after adding new strings or changing existing ones in the Lua scripts
#
# Usage: python update_strings.py
#

WORKING_DIRS = [".", "editor"]
JSON_FILE = "strings.json"
GCT_FUNC = "gct"
LUA_FILE_EXT = ".lua"

import os
import json

# https://github.com/boolangery/py-lua-parser
try:
    from luaparser import ast
except ImportError:
    print("Install luaparser: pip install luaparser")
    exit()

def get_defined_strings():
    if not os.path.exists(JSON_FILE):
        return []
    try:
        with open(JSON_FILE, "r") as f:
            return json.load(f)
    except:
        return []

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
        if file.endswith(LUA_FILE_EXT):
            file_path = os.path.join(dir_path, file)
            strings.extend(get_strings_from_file(file_path))
    return strings

print("Searching for strings used by " + GCT_FUNC + " in " + str(WORKING_DIRS))

try:
    prev_strings = get_defined_strings()
    if prev_strings is None:
        prev_strings = {}

    strings = []
    for dir in WORKING_DIRS:
        strings.extend(get_strings_from_dir(dir))
    strings = { s: { "value": s, "rgb": [255, 255, 255] } for s in strings }
    for s in strings:
        if s in prev_strings:
            strings[s]["rgb"] = prev_strings[s]["rgb"]

    with open(JSON_FILE, "w") as f:
        f.truncate(0)
        json.dump(strings, f, indent=4)

    print("Updated " + JSON_FILE + " with " + str(len(strings)) + " strings")
except Exception as e:
    print("Error: " + str(e))