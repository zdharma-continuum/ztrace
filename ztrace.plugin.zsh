# Saved stdout descriptor
typeset -g ZTRACE_FD
# Path to directory where traces are saved
typeset -g ZTRACE_PATH="/tmp/ztrace-$$"
# Name of file being currently used
typeset -g ZTRACE_FNAME=""
# Decreased on each command execution
integer -g ZTRACE_COUNT=0
# Is Ztrace in progress?
integer -g ZTRACE_IN_PROGRESS=0

##
## User exposed functions {{{
##

ztstart() {
    integer num="$1"

    if [ "$ZTRACE_PATH" = "/tmp/" ]; then
        print "Error occured, ZTRACE_PATH is just '/tmp'"
        return 1
    fi

    # Create destination path for the process
    command mkdir -p "$ZTRACE_PATH"

    ZTRACE_COUNT=num
    ZTRACE_IN_PROGRESS=1
    local fname=$(date +%Y.%m.%d_%H:%M:%S)".ztrace"
    ZTRACE_FNAME="$fname"
    -zt-pinfo "Ztrace started"

    # Save std out
    exec {ZTRACE_FD}>&1
    exec > >(tee -a "$ZTRACE_PATH/$fname")
}

ztstop() {
    ZTRACE_IN_PROGRESS=0
    exec >&$ZTRACE_FD && exec {ZTRACE_FD}>&-
    -zt-pinfo "Ztrace stopped"
    ZTRACE_FNAME=""
}

#
# Shows how many more commands will be catched
#
ztstatus() {
    (( ZTRACE_COUNT ++ ))
    print "Ztrace will catch $ZTRACE_COUNT following commands"
}

## }}}

##
## Private functions {{{
##

#
# Hook that counts number of commands executed
# and stops ztrace when it's time
#
-zt-precmd() {
    (( ZTRACE_COUNT-- ))
    if [[ "$ZTRACE_COUNT" -lt 0 && "$ZTRACE_IN_PROGRESS" = "1" ]]; then
        ztstop
    elif [ "$ZTRACE_IN_PROGRESS" = "1" ]; then
        print "\\n-------------" >> "$ZTRACE_PATH/$ZTRACE_FNAME"
    fi
}

## }}}

##
## Utility functions {{{
##

-zt-pinfo() { print "${fg_bold[green]}$*$reset_color"; }
-zt-perror() { print "${fg_bold[red]}$*$reset_color"; }

## }}}

##
## Load-time code
##

#
# Startup
#
-zt-init() {
    setopt localoptions nullglob

    # Cleary any possible left overs from previous sessions
    typeset -a traces
    traces=( "$ZTRACE_PATH"/*.ztrace )
    if [[ "${#traces}" -gt 0 ]]; then
        command rm -f "${traces[@]}"
    fi

    if [[ "$+fg_bold" -eq 0 ]]; then
        autoload colors
        colors
    fi

    autoload add-zsh-hook
    add-zsh-hook precmd -zt-precmd
}

-zt-init

autoload h2-list h2-list-input h2-list-draw
autoload ztrace ztrace-usetty-wrapper ztrace-widget

zle -N ztrace-widget
bindkey "^G" ztrace-widget
