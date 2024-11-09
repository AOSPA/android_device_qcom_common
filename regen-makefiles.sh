#!/bin/bash

find . -mindepth 2 -name extract-files.py -exec sh -c 'echo "Executing: {}"; cd "$(dirname "{}")" && ./extract-files.py -m' \;
