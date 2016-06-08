#!/bin/sh

InstallationDir="${InstallationDir:-/var/service}"

usage() {
    echo "$0 [--develop|--production] [-i|--install] [-p|--purgue]"
    echo " --develop, --production: type of script to use in the install or purgue, environment develop or production"
    echo " -i, --install:           install packages"
    echo " -p, --purgue:            purgue packages"
}

chargeProductionListDependencies() {
    if [ $1 == true ]; then
        source "$InstallationDir"/dependencies-extra.list
        source "$InstallationDir"/alpine-dependencies-extra.list
    fi
}

chargeDevelopListDependencies() {
    if [ $1 == true ]; then
        source "$InstallationDir"/dependencies-dev.list
        source "$InstallationDir"/alpine-dependencies-dev.list
    fi
}

executeInstall() {
    if [ $1 == true ]; then
        service="add"
        eval dependencies=\$$service
        if [ ${#dependencies} -gt 0 ]; then
            if [ $2 == true ]; then
                /scripts-base/installExtraBuild-new.sh $dependencies
            fi
            if [ $3 == true ]; then
                /scripts-base/installDevBuild.sh $dependencies
            fi
        else
            echo "Dependencies doesn't available"
        fi
    fi
}

executePurgue() {
    if [ $1 == true ]; then
        service="del"
        eval dependencies=\$$service
        if [ ${#dependencies} -gt 0 ]; then
            if [ $2 == true ]; then
                /scripts-base/deleteExtraBuild-new.sh $dependencies
            fi
            if [ $3 == true ]; then
                /scripts-base/deleteDevBuild.sh $dependencies
            fi
        else
            echo "Dependencies doesn't available"
        fi
    fi
}

if [ "$#" -eq 0 ]
then
    usage
    exit
fi

develop=false
production=false
purgue=false

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
    esac
done

chargeProductionListDependencies $production
chargeDevelopListDependencies $develop

executeInstall $install $production $develop
executePurgue $purgue $production $develop
