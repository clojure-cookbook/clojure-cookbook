#!/bin/bash
# Running more than once is ok.
# Files will not be modified or replaced
# if they already exist
# Assumes Mac OS X, Brew installer

echo "Begin Setup"

# Install asciidoc
test -x `which asciidoc` || (echo "Installing asciidoc" && brew install asciidoc)

# Install source-highlight
test -x `which source-highlight` || (echo "Installing source-highlight" && brew install source-highlight)

# Assume brew is going to use /usr/local/share/source-highlight
SOURCE_HIGHLIGHT_DIR="/usr/local/share/source-highlight"
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
test -f $CLOJURE_LANG_FILE || (echo "********** Adding $CLOJURE_LANG_FILE **********" && wget -O $CLOJURE_LANG_FILE $CLOJURE_LANG_SOURCE)

# JSON highlighting support
test -f $JSON_LANG_FILE || (echo "********** Adding $JSON_LANG_FILE **********" && wget -O $JSON_LANG_FILE $JSON_LANG_SOURCE)
test -f $JSON_STYLE_FILE || (echo "********** Adding $JSON_STYLE_FILE **********" && wget -O $JSON_STYLE_FILE $JSON_STYLE_SOURCE)

# CSV/text/plain highlighting
# This is to avoid errors more than actually highlight anything.
test -f $PLAIN_LANG_FILE || (echo "********** Adding $PLAIN_LANG_FILE **********" && cat <<END > $PLAIN_LANG_FILE)
include "number.lang"
include "symbols.lang"
cbracket = "{|}"
END

# Add mappings to /usr/local/share/source-highlight/lang.map
# DO NOT REMOVE lang.map -- it has other mappings
LANG_MAP_FILE="/usr/local/share/source-highlight/lang.map"
if [[ "`grep clojure $LANG_MAP_FILE`" == "" ]] ; then
  echo "********** Appending to $LANG_MAP_FILE **********"
  cat <<END >> $LANG_MAP_FILE
clojure = clojure.lang
clj = clojure.lang
console = sh.lang
csv = plain.lang
json = json.lang
plain = plain.lang
terminal = sh.lang
text = plain.lang
END

  echo "Cleaning $LANG_MAP_FILE"
  cat $LANG_MAP_FILE |sort|uniq >$LANG_MAP_FILE
fi

echo "Setup Complete"
