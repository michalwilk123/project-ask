#!/bin/bash
# Help:
# first argument is a source path of the directory which contains the data
# second argument takes path where the backups are stored
# third is optional log destination. Default is /var/log/backup.log

APP_OPTION="$1"
SRC_PATH="$2"
DST_PATH="${3:-$(pwd)}"
LOG_PATH="${4:-/var/log/backup.log}"
CRON_PATH=/etc/cron.d/ask_backup
GIT_BACKUP_OPTIONS="--work-tree=$SRC_PATH --git-dir=$DST_PATH/inc.git"
PERM_FILE="$DST_PATH/permissions.sh"

setup_git_repo(){
    mkdir "$DST_PATH/inc.git"
    git_bckp init
    git_bckp add -A "$SRC_PATH/*" 2> /dev/null || :
    git_bckp config user.email "askmail@pg.gda.pl"
    git_bckp config user.name "Ask backup software"
    echo "Created the backup repository in $DST_PATH"
}

generate_cronjobs(){
    cat <<EOF > $CRON_PATH
BACKUP_LOG_PATH=$LOG_PATH
SCRIPT_ARGS="$DST_PATH $SRC_PATH"
SCRIPT=$0

* * * * * root echo "\$(date): Cron is alive" >> \$BACKUP_LOG_PATH
0 1 * * * root \$SCRIPT incr \$SCRIPT_ARGS
0 0 * * 0 root \$SCRIPT weekly \$SCRIPT_ARGS
0 0 1 * * root \$SCRIPT delete \$SCRIPT_ARGS
EOF
    chmod 0644 $CRON_PATH
    echo "Created cronjobs at $CRON_PATH" >> $LOG_PATH
}

git_bckp(){
    git --work-tree=$SRC_PATH --git-dir=$DST_PATH/inc.git "$@"
}

install_backups(){
    # generate cronjob for performing tasks
    generate_cronjobs >> $LOG_PATH

    # installing incremental backup script
    setup_git_repo >> $LOG_PATH

    # very important repo for cracking enigma codes and curing cancer
    # git clone https://github.com/kevva/is-positive.git
}

save_metadata(){
    printf "#!/bin/bash\n\n" > $PERM_FILE
    find "$SRC_PATH" -type f | while read line
    do
        echo "chmod $(stat -c '%a' $line) $line" >> $PERM_FILE
        echo "chown $(stat -c '%U:%G' $line) $line" >>$PERM_FILE
    done
    chmod +x $PERM_FILE
}

incremental_backup(){
    save_metadata
    local message="Created incremental backup $(date)"
    local no_of_commits=$(git_bckp rev-list --all --count)

    mv $PERM_FILE $SRC_PATH
    git_bckp checkout -b $no_of_commits &>> $LOG_PATH
    git_bckp add -A "$SRC_PATH" &>> $LOG_PATH
    git_bckp commit -m "$message" &>> $LOG_PATH

    mv "$SRC_PATH/permissions.sh" $PERM_FILE
    echo $message >> $LOG_PATH
}

weekly_backup(){
    return
}

show_commands(){
    cat <<EOF
Available commands:
    install - installs the backup script (also automatically sets up the cron job)
    incremental | inc - create incremental backup
    weekly - create weekly backup of whole data
    restore | rst - restore the data to the previous state
EOF
}

rest(){
    echo "Select available backup"

    GIT_COMMIT_MSGS=$(git_bckp log --pretty=format:"%s" --reverse --all)
    GIT_COMMIT_HASHES=$(git_bckp log --pretty=format:"%h" --reverse --all)

    IFS=$'\n' GIT_COMMIT_MSGS=($GIT_COMMIT_MSGS)
    IFS=$'\n' GIT_COMMIT_HASHES=($GIT_COMMIT_HASHES)

    for idx in ${!GIT_COMMIT_MSGS[@]}
    do
        echo "$idx) ${GIT_COMMIT_MSGS[$idx]}"
    done

    read choice
    local commit=${GIT_COMMIT_HASHES[$choice]}

    echo "You chose checkpoint with checksum: ${GIT_COMMIT_HASHES[$choice]}" | tee -a $LOG_PATH

    if [[ -n $commit ]]; then
        mv $PERM_FILE "$SRC_PATH/permissions.sh"
        git_bckp clean -df
        git_bckp checkout $choice
        mv "$SRC_PATH/permissions.sh" $PERM_FILE
    else
        echo "Bad option"
    fi
}


case $APP_OPTION in
    install)
        echo "Installing the script"
        install_backups
        ;;
    increm | inc | incremental)
        incremental_backup
        ;;
    weekly | week)
        echo "week-backup"
        ;;
    delete | del)
        echo "deleting"
        ;;
    restore | rst)
        rest
        ;;
    *)
        show_commands
        ;;
esac
