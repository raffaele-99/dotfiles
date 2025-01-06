#!/usr/bin/env python

import sys, json

def json_to_yaml(d, indent=0):
    spaces = "  " * indent
    if isinstance(d, dict):
        for key, value in d.items():
            print(f"{spaces}{key}:")
            json_to_yaml(value, indent + 1)
    elif isinstance(d, list):
        for item in d:
            print(f"{spaces}-")
            json_to_yaml(item, indent + 1)
    else:
        print(f"{spaces}{d}")

json_to_yaml(json.load(sys.stdin))

