#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5000)); then
    exit 60
else
    curl --silent --fail lndhub.embassy:3000 &>/dev/null
    RES=$?
    if test "$RES" != 0; then
        echo "API is unreachable" >&2
        exit 1
    fi
fi
