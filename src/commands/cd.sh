
function cdprj {
    if ! ensure_active_project
    then
        err "There is no currently active project; run prj first"
        return 1
    fi

    local project_name=$(active_project)
    cd $(project_path_from_name $project_name)
}