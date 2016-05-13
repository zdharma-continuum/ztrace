# Saved stdout descriptor
typeset -g ZTRACE_FD
# Path to directory where traces are saved
typeset -g ZTRACE_PATH="/tmp/ztrace-$$"
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

    ZTRACE_COUNT=num
    ZTRACE_IN_PROGRESS=1
    local fname=$(date +%Y.%m.%d_%H:%M:%S)".ztrace"
    -zt-pinfo "Ztrace started"

    # Save std out
    exec {ZTRACE_FD}>&1
    exec > >(tee -a "$ZTRACE_PATH/$fname")
}

ztstop() {
    ZTRACE_IN_PROGRESS=0
    exec >&$ZTRACE_FD && exec {ZTRACE_FD}>&-
    -zt-pinfo "Ztrace stopped"
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
    if [[ "$ZTRACE_COUNT" -lt 0 && "$ZTRACE_IN_PROGRESS" -eq "1" ]]; then
        ztstop
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

    # Create destination path for the process
    command mkdir -p "$ZTRACE_PATH"

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
