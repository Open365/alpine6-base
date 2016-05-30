#!/bin/sh

extraPack="";
if [ "$#" -ge "0" ]; then
    extraPack=$@;
fi

apk del curl make gcc g++ git python $extraPack