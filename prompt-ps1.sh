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

# the fancy colorized prompt: [0 user@host ~]$
# return code is in green, user@host is in yellow[white]magenta cyan
export PS1='[\[\033[1;32m\]$?\[\033[0;0m\] \[\033[0;33m\]\u\[\033[2;0m\]@\[\033[0;35m\]\h\[\033[0;36m\] $(eval "echo ${MYPSDIR}")\[\033[0;0m\]]\n$ '

# set x/ssh window title as well
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*} $(eval "echo ${MYPSDIR}")\007"'
