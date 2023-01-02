#!/bin/bash

# @raycast.title Search in Private/Incognito Browser
# @raycast.author Ettemlevest
# @raycast.authorURL https://github.com/Ettemlevest
# @raycast.description Open the given URL in a private browser

# @raycast.icon 🔍
# @raycast.mode silent
# @raycast.packageName Browser
# @raycast.schemaVersion 1

# @raycast.argument1 { "type": "text", "placeholder": "Search term" }

SEARCH_TERM=$1

URL="https://google.com/search?q=$SEARCH_TERM"

/Applications/Microsoft\ Edge.app/Contents/MacOS/Microsoft\ Edge --inprivate "$URL"
