#!/bin/bash

# Brew-based bootstrap script for setting up an OS X system to build
# Clojure Cookbook
#
# This script assumes your SOURCE_HIGHLIGHT_DIR is
# /usr/local/share/source-highlight. If it isn't, override the environment
# variable when you run this script:
#
#  $ SOURCE_HIGHLIGHT_DIR=/foo/bar ./script/asciidoc/bootstrap_osx.sh
#
# Files will not be modified or replaced if they already exist
#
# Running this script more than once is OK.

set -e

echo "Begin Setup"

# Install asciidoc
command -v asciidoc >/dev/null 2>&1 || {
  echo "Installing asciidoc"
  brew install asciidoc
}

# Install source-highlight
command -v source-highlight >/dev/null 2>&1 || {
  echo "Installing source-highlight"
  brew install source-highlight
}

# Install wget
command -v wget >/dev/null 2>&1 || {
    echo "Installing wget"
    brew install wget
}

# Assume brew is going to use /usr/local/share/source-highlight
SOURCE_HIGHLIGHT_DIR="${SOURCE_HIGHLIGHT_DIR:-/usr/local/share/source-highlight}"
CLOJURE_LANG_FILE="${SOURCE_HIGHLIGHT_DIR}/clojure.lang"
JSON_LANG_FILE="${SOURCE_HIGHLIGHT_DIR}/json.lang"
JSON_STYLE_FILE="${SOURCE_HIGHLIGHT_DIR}/json.style"
PLAIN_LANG_FILE="${SOURCE_HIGHLIGHT_DIR}/plain.lang"

CLOJURE_LANG_SOURCE="https://gist.github.com/alandipert/265810/raw/8dec04317e02187b03e96bb1e0206e154e0ae5e2/clojure.lang"
JSON_LANG_SOURCE="https://raw.github.com/freeformsystems/rlx/master/highlight/json.lang"
JSON_STYLE_SOURCE="https://raw.github.com/freeformsystems/rlx/master/highlight/json.style"

# uncomment the following to debug/start fresh
# does not clean LANG_MAP_FILE
## rm $CLOJURE_LANG_FILE $JSON_LANG_FILE $JSON_STYLE_FILE $PLAIN_LANG_FILE

# Clojure highlighting support
test -f "$CLOJURE_LANG_FILE" || (echo "********** Adding $CLOJURE_LANG_FILE **********" && wget --no-check-certificate -O $CLOJURE_LANG_FILE $CLOJURE_LANG_SOURCE)

# JSON highlighting support
test -f "$JSON_LANG_FILE" || (echo "********** Adding $JSON_LANG_FILE **********" && wget --no-check-certificate -O $JSON_LANG_FILE $JSON_LANG_SOURCE)
test -f "$JSON_STYLE_FILE" || (echo "********** Adding $JSON_STYLE_FILE **********" && wget --no-check-certificate -O $JSON_STYLE_FILE $JSON_STYLE_SOURCE)

# CSV/text/plain highlighting
# This is to avoid errors more than actually highlight anything.
test -f "$PLAIN_LANG_FILE" || (echo "********** Adding $PLAIN_LANG_FILE **********" && cat <<END > $PLAIN_LANG_FILE)
include "number.lang"
include "symbols.lang"
cbracket = "{|}"
END

LANG_MAP_FILE="$SOURCE_HIGHLIGHT_DIR/lang.map"

# Add mappings to $SOURCE_HIGHLIGHT_DIR/lang.map
# DO NOT REMOVE lang.map -- it has other mappings
grep shell-session "$LANG_MAP_FILE" >/dev/null || {
  echo "********** Backing up original $LANG_MAP_FILE to ${LANG_MAP_FILE}.bak"
  cp "$LANG_MAP_FILE" "${LANG_MAP_FILE}.bak"

  echo "********** Appending to $LANG_MAP_FILE"
  cat <<END >> "$LANG_MAP_FILE"

clojure = clojure.lang
csv = plain.lang
json = json.lang
plain = plain.lang
shell-session=sh.lang
END

  echo "Cleaning $LANG_MAP_FILE"
  cleaned_contents="`sort "$LANG_MAP_FILE" | uniq`"
  echo "$cleaned_contents" > "$LANG_MAP_FILE"

}

echo "Setup Complete"
