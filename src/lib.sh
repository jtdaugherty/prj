#!/bin/bash

# Library script for prj.

#######################################################
# Virtual paths

# Path to directory managed by prj.
PRJ_DIR=prj

# Path to host-specific scripts directory
HOSTS_DIR=$PRJ_DIR/hosts

# Path to autoload directory
AUTOLOAD_DIR=$PRJ_DIR/autoload.d

# Main script path
MAIN_SCRIPT_PATH=$PRJ_DIR/main.sh

#######################################################
# Real paths

# Path to directory where projects are registered
REGISTRY=$HOME/.projects/

function local_readlink {
    local rl=""

    # Is the readlink GNU-like?  Does -f mean what we expect?
    if which readlink > /dev/null && readlink -f x >/dev/null 2>&1
    then
        rl=readlink
    elif which greadlink > /dev/null
    then
        rl=greadlink
    fi

    if [[ "$rl" == "" ]]
    then
        err "prj requires a GNU-like readlink tool; tried 'readlink' and 'greadlink'."
        return 1
    else
        $rl $@
    fi
}

function verbose {
    if [[ $VERBOSE > 0 ]]
    then
        echo "$@"
    fi
}

function notice {
    if [ "$SILENT" == "" ]
    then
        echo "$@"
    fi
}

function err {
    echo "$@"
}

function load_commands {
    local path=$1
    verbose "Loading commands:"

    for f in $path/*.sh
    do
        verbose "  $f"
        . $f
    done
    verbose "done."
}

# Returns 0 if $1 (a path) is a project directory (contains a project
# scripts subdirectory)
function is_project {
    local path=$1
    if [[ -e $path/$PRJ_DIR ]]
    then
        return 0
    else
        return 1
    fi
}

function strict_mkdir {
    if ! mkdir $1
    then
        err "Failed to create subdirectory $1"
        return 1
    fi
    return 0
}

function ensure_dir {
    if [[ ! -e $1 ]]
    then
        strict_mkdir $1
    fi
}

function registered_project_names {
    ensure_dir $REGISTRY || return 1

    for f in $(all_files $REGISTRY)
    do
        echo $f
    done
}

function all_files {
    local path=$1;

    for f in $path/*
    do
        # Disgusting hack since the * will not expand to the empty
        # list
        if [ "$f" == "$path/*" ]
        then
            return 0
        fi

        echo $(basename $f)
    done
}

function project_path_from_name {
    local project_name=$1;

    ensure_registered_name $project_name && \
        local_readlink -f $REGISTRY/$1
}

function ensure_registered_name {
    local project_name=$1;
    ensure_dir $REGISTRY || return 1

    for p_name in $(registered_project_names)
    do
        if [ "$p_name" == "$project_name" ]
        then
            return 0
        fi
    done
    return 1;
}

function ensure_registered_path {
    local path=$1;
    ensure_dir $REGISTRY || return 1

    for p_name in $(registered_project_names)
    do
        if [ $(project_path_from_name $p_name) == "$path" ]
        then
            return 0
        fi
    done
    return 1;
}

function project_name_from_path {
    local path=$1;

    for p_name in $(registered_project_names)
    do
        p_path=$(project_path_from_name $p_name)

        if [ "$p_path" == "$path" ]
        then
            echo $p_name
            return 0
        fi
    done

    return 1;
}

function ensure_active_project {
    if [ "$PRJ" == "" ]
    then
        return 1
    fi
    return 0
}

function active_project {
    ensure_active_project && echo $PRJ
}

function clear_active_project {
    export PRJ=
}

function resolve_path {
    echo $1
}

function in_PATH {
    local _ENTRY=$(resolve_path $1)

    for entry in $(split_PATH)
    do
        if [ "$entry" == "$_ENTRY" ]
        then
            return 0
        fi
    done

    return 1
}

function add_PATH {
    local _NEW_ENTRY=$1

    if ! in_PATH $_NEW_ENTRY
    then
        PATH=$_NEW_ENTRY:$PATH
    fi
}

function split_PATH {
    for entry in $(echo $PATH | sed "s/:/ /g")
    do
        echo $(resolve_path $entry)
    done
}
