# Author: https://github.com/Fernando-A-Rocha
# 
# For developers
# 
# Finds all .lua files in the given directories
# Updates JSON file with all strings used by the Lua scripts
# Run this script after adding new strings or changing existing ones in the Lua scripts
#
# Dependencies:
# - luaparser (https://github.com/boolangery/py-lua-parser)
#
# Usage: python update_strings.py
#

WORKING_DIRS = [".", "editor"]
JSON_FILE = "strings.json"
GCT_FUNC = "gct"
LUA_FILE_EXT = ".lua"

import os
import json

try:
    from luaparser import ast
except ImportError:
    print("Missing dependency: pip install luaparser")
    exit()

def get_defined_strings():
    try:
        if not os.path.exists(JSON_FILE):
            return {}
        with open(JSON_FILE, "r") as f:
            return json.load(f)
    except:
        return {}

def get_strings_from_file(file_path):
    with open(file_path, "r") as f:
        tree = ast.parse(f.read())
        strings = {}
        for node in ast.walk(tree):
            if isinstance(node, ast.Call):
                if isinstance(node.func, ast.Name) and node.func.id == GCT_FUNC:
                    if isinstance(node.args[0], ast.String):
                        strings.update({ node.args[0].s: { "value": node.args[0].s, "rgb": [255, 255, 255] } })
        return strings

print("Searching for strings used by " + GCT_FUNC + " in " + str(WORKING_DIRS))

try:
    strings_defined = get_defined_strings()
    strings = {}

    for dir_path in WORKING_DIRS:
        for file in os.listdir(dir_path):
            if file.endswith(LUA_FILE_EXT):
                file_path = os.path.join(dir_path, file)
                strs = get_strings_from_file(file_path)
                for key in strs:
                    if key in strings_defined:
                        strs[key] = strings_defined[key]
                strings.update(strs)

    with open(JSON_FILE, "w") as f:
        f.truncate(0)
        json.dump(strings, f, indent=4)

    print("Updated " + JSON_FILE + " with " + str(len(strings)) + " strings")
except Exception as e:
    print("Error: " + str(e))