
function prj-load() {
    local project_name=$1

    if ensure_active_project
    then
        err "Project '$(active_project)' already active; reloading"
        prj-reload
        return 0
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

    local path=$(project_path_from_name $project_name)

    # Set these variables now so they'll be available for the
    # project's scripts
    export PRJ=$project_name
    export PRJ_HOME=$path

    # Load the project's main script
    . $path/$MAIN_SCRIPT_PATH || { clear_active_project; return 1; }

    # Load the project's autoload scripts (order should be
    # unimportant)
    for f in $(all_files $path/$AUTOLOAD_DIR)
    do
        . $path/$AUTOLOAD_DIR/$f
    done

    # Load the host-specific script, if any
    local host_script=$path/$HOSTS_DIR/$(hostname)/main.sh
    if [ -e $host_script ]
    then
        . $host_script
    fi

    # Load the user-specific script, if any
    local user_script=$path/$HOSTS_DIR/$(hostname)/users/$(whoami).sh
    if [ -e $user_script ]
    then
        . $user_script
    fi

    # Set up the project-specific shell history (but only if we aren't
    # reloading a project)
    if [ "$OLD_PRJ" == "" ]
    then
        # Flush the existing history
        history -a

        # Set HISTFILE
        export HISTFILE=$path/$HISTORY_PATH

        # Load the history from the new history file
        history -r
    fi

    # Change prompt
    if [ "$PRJ_NO_AUTO_PROMPT" == "" ]
    then
        if [ "$OLD_PS1" == "" ]
        then
            # Prompt has never been backed up so we can save it
            export OLD_PS1=$PS1
        fi

        export PS1="<$PRJ> $OLD_PS1"
    fi

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

    prj-load $project_name

    # Change to project directory
    cdprj
}

function prj-reload {
    if ! ensure_active_project
    then
        err "There is no currently active project; run prj first"
        return 1
    fi

    local project_name=$(active_project)

    notice "Reloading $project_name"

    export OLD_PRJ=$PRJ
    clear_active_project
    prj-load $project_name
}