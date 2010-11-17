
function prj-unregister {
    local path=$(pwd)
    local project_name=$(basename $path)

    # XXX make it so that a path can be unregistered even if it is not
    # a project (i.e., it got removed but is still registered)

    # Also do something about registered projects that don't even
    # exist

    # Also make it so you can specify a project name OR path instead
    # of assuming the cwd

    (is_project $path ||
        (echo "$path is not a project; run prj-init instead" && return 1)) && \
        (ensure_registered_path $path ||
        (echo "$path is not registered; run prj-register to register it" && return 1)) && \
        rm -f $REGISTRY/$project_name && \
        notice "Project $project_name unregistered"
}