
function prj-register {
    local path=$(pwd)
    local project_name=$(basename $path)

    ensure_dir $REGISTRY && \
        (is_project $path ||
        (echo "$path is not a project; run prj-init instead" && return 1)) && \
        ((! ensure_registered_path $path) ||
        (echo "$path is already registered as $(project_name_from_path $path)" && return 1)) && \
        ln -s $path $REGISTRY/$project_name && \
        notice "Registered $project_name in $REGISTRY"
}