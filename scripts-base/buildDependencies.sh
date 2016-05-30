#!/bin/sh

usage() {
    echo "$0 [--develop|--production] [-i|--install] [-p|--purgue] -c=<package_common> --deps=<list_dependencies>"
    echo " --develop, --production: type of script to use in the install or purgue, environment develop or production"
    echo " -i, --install:           install packages"
    echo " -p, --purgue:            purgue packages"
    echo " -c, --common:            value 'true' o 'false', install common packages"
    echo " --deps, --dependencies:  list of differents packages to install or purgue, separate by a whitespace as a string"
}

if [ "$#" -eq 0 ]
then
    usage
    exit
fi

develop=false
production=false
install=false
purgue=false
common=false
dependecies=""
existDepends=false

for i in "$@"
do
    case $i in
        --develop)
        develop=true
        production=false
        shift
        ;;
        --production)
        develop=false
        production=true
        shift
        ;;
        -i|--install)
        install=true
        purgue=false
        shift
        ;;
        -p|--purgue)
        install=false
        purgue=true
        shift
        ;;
        -c=*|--common=*)
        common="${i#*=}"
        if [ "$common" != "true" ] && [ "$common" != "false" ]
        then
            usage
            exit
        fi
        if [ "$common" == "true" ]
        then
            common=true
        else
            common=false
        fi
        shift
        ;;
        --deps=*|--dependencies=*)
        existDepends=true
        dependencies="${i#*=}"
        shift
        ;;
    esac
done

if [ $common == true ]; then
    if [ $install == true ]; then
        if [ $production == true ]; then
            /scripts-base/installExtraBuild.sh $dependencies
        fi
        if [ $develop == true ]; then
            /scripts-base/installDevBuild.sh $dependencies
        fi
    fi
    if [ $purgue == true ]; then
        if [ $production == true ]; then
            /scripts-base/deleteExtraBuild.sh $dependencies
        fi
        if [ $develop == true ]; then
            /scripts-base/deleteDevBuild.sh $dependencies
        fi
    fi
else
    if [ $existDepends == true ]; then
        if [ $install == true ]; then
            apk add --no-cache $dependencies
        fi
        if [ $purgue == true ]; then
            apk del $dependencies
        fi
    fi
fi