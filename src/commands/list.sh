
function prj-list {
    ensure_dir $REGISTRY

    local i=0;
    for p_name in $(registered_project_names)
    do
        path=$(project_path_from_name $p_name)
        printf "%-15s%s\n" $p_name $path
        i=$i+1;
    done

    if [ $i == 0 ]
    then
        notice "No projects registered."
    fi
}