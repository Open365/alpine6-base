#!/bin/sh

extraPack="";
if [ "$#" -ge "0" ]; then
    extraPack=$@;
fi

apk del $extraPack