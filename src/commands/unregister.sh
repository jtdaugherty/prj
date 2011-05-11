
function prj-unregister {
    local path=""

    if [[ "$1" != "" ]]
    then
        path=$1
    else
        path=$(pwd)
    fi

    local project_name=$(basename $path)

    # Also do something about registered projects that don't even
    # exist

    # Also make it so you can specify a project name OR path

    (ensure_registered_path $path ||
        (echo "$path is not registered; run prj-register to register it" && return 1)) && \
        rm -f $REGISTRY/$project_name && \
        notice "Project $project_name unregistered"
}