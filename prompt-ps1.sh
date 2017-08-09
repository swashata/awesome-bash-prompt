# define the awk script using heredoc notation for easy modification
MYPSDIR_AWK=$(cat << 'EOF'
BEGIN { FS = OFS = "/" }
{
   sub(ENVIRON["HOME"], "~");
   if (length($0) > 16 && NF > 4)
      print $1,$2,".." NF-4 "..",$(NF-1),$NF
   else
      print $0
}
EOF
)

# my replacement for \w prompt expansion
export MYPSDIR='$(echo -n "$PWD" | awk "$MYPSDIR_AWK")'

function is_git_prompt_disabled() {
    # Conditionally add the branch if oh-my-git is disabled
    local git_enabled=`git config --get oh-my-git.enabled`
    local branch_info=''
    if [[ ${git_enabled} == false ]]; then
        branch_info="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" || branch_info="unnamed branch"
        echo -e "\e[0;0m \e[35m${i_oct_git_branch} \e[0;0m${branch_info}"
    fi
}

# the fancy colorized prompt: [0 user@host ~]$
# return code is in green, user@host is in yellow[white]magenta cyan
export PS1='[\[\033[1;32m\]$?\[\033[0;0m\] \[\033[0;33m\]\u\[\033[2;0m\]@\[\033[0;35m\]\h\[\033[0;36m\] $(eval "echo ${MYPSDIR}")\[\033[0;0m\]]$(is_git_prompt_disabled)\n$ '

# set x/ssh window title as well
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*} $(eval "echo ${MYPSDIR}")\007"'
