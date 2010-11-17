
function prj-load() {
    local project_name=$1

    if ensure_active_project
    then
        err "Project '$(active_project)' already active"
        return 1
    fi

    if [ "$project_name" == "" ]
    then
        notice "Usage: prj-load <project name>"
        notice "Choices:"
        prj-list
        return 0
    fi

    if ! ensure_registered_name $project_name
    then
        err "'$project_name' is not a registered project"
        return 1
    fi

    # Load the project's main script

    # Load the project's autoload scripts (order should be
    # unimportant)

    # Load the host-specific script, if any

    # Load and fixup the shell history

    export PRJ=$project_name
    notice "Project '$project_name' loaded"
}

function prj {
    local project_name=$1;

    if [ "$project_name" == "" ]
    then
        notice "Usage: prj <project name>"
        notice "Choices:"
        prj-list
        return 0
    fi

    if ! ensure_registered_name $project_name
    then
        err "'$project_name' is not a registered project"
        return 1
    fi

    # Change to project directory
    cd $(project_path_from_name $project_name)

    prj-load $project_name
}

function prj-reload {
    if ! ensure_active_project
    then
        err "There is no currently active project; run prj first"
        return 1
    fi

    local project_name=$(active_project)

    echo "Reloading $project_name"
    clear_active_project
    prj-load $project_name
}