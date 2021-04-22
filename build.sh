#!/usr/bin/env sh
set -x

find_packages() {
    last=${DRONE_COMMIT_BEFORE}
    if [[ z"${DRONE_COMMIT_BRANCH}" != z"master" ]]
    then
        git fetch origin master
        last="origin/master"
    fi
    
    build_packages=$(git diff --name-status ${last} repo/*/PKGBUILD | sed -r 's/^[AM]\trepo\/(.*)\/PKGBUILD$/\1/g'| sort | uniq | tee .build_packages)
    if [ -z "${build_packages}" ]
    then
        echo "Package not found!"
        exit 255
    fi
}

build_package() {
    package=$1
    pushd repo/${package}/
    makepkg -csf --noconfirm --skippgpcheck
    popd
}

build_all() {
    sudo pacman -Sy
    while read package
    do
        build_package ${package}
    done < .build_packages
}

main() {
    case $1 in
    find_packages)
        find_packages 
        ;;
    build_all)
        build_all
        ;;
    *)
        build_all
        ;;
    esac
}

main $@
