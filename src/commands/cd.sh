
function cdprj {
    if ! ensure_active_project
    then
        err "There is no currently active project; run prj first"
        return 1
    fi

    cd $PRJ_HOME
}