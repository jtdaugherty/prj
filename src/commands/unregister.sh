
function prj-unregister {
    local path=$(pwd)
    local project_name=$(basename $path)

    (is_project $path ||
        (echo "$path is not a project; run prj-init instead" && return 1)) && \
        (ensure_registered_path $path ||
        (echo "$path is not registered; run prj-register to register it" && return 1)) && \
        rm -f $REGISTRY/$project_name && \
        notice "Project $project_name unregistered"
}