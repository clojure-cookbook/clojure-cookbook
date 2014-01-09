#!/bin/sh

find . -name \*.asciidoc -ls -exec asciidoc -b html5 {} \; 2>&1 |grep -v "section title out of seq"

