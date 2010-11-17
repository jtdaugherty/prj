
function prj-init {
    local path=$(pwd)

    if is_project $path
    then
        err "$path is already a project directory."
        return 1
    fi

    strict_mkdir $path/$PRJ_DIR && \
        strict_mkdir $path/$HOSTS_DIR && \
        strict_mkdir $path/$AUTOLOAD_DIR && \
        touch $path/$MAIN_PATH && \
        notice "Created project directory in $path" && \
        prj-register
}