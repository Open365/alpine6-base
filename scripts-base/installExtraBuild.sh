#!/bin/sh

extraPack="";
if [ "$#" -ge "0" ]; then
    extraPack=$@;
fi

apk add --no-cache curl make gcc g++ git python $extraPack