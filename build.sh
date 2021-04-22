#!/usr/bin/env sh
set -x

find_packages() {
    git diff --name-status master repo/*/PKGBUILD | sed -r 's/^[AM]\trepo\/(.*)\/PKGBUILD$/\1/g'| sort | uniq | tee .build_packages | xargs printf "find package: %s\n" 
}

build_package() {
    package=$1
    pushd repo/${package}/
    makepkg -csf
    popd
}

build_all() {
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
