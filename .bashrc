#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

function generate_prompt() {
    local simple=$1

    local usr_host='\u@\h'
    local wkdir='\W'
    local end='\$ '

    local nc='\[\e[0m\]'
    local grey="$nc"'\[\e[1;90m\]'
    local white="$nc"'\[\e[1;88m\]'
    local blue="$nc"'\[\e[1;3;94m\]'

    if [ "$simple" -ne 0 ]; then
        echo "[$usr_host $wkdir]$end"
    else
        local git_branch='$(__git_ps1 "%s" | grep -o "[^/]*$")'
        local cat_branch='$(txt="'"${git_branch}"'"; if [ ${#txt} -gt 16 ]; then echo "${txt::13}..."; else echo "${txt}"; fi)'

        echo "$grey[$usr_host $blue$wkdir$grey]($white$cat_branch$grey)$end$nc"
    fi
}

alias ls='ls --color=auto'
alias reboot='read -p "You _really_ want to reboot your laptop? Smartass -_- (ctrl-c to cancel)[y/n]: " reply && [ $reply = "y" ] && systemctl reboot'

function untar-rm() {
    local file=${1}
    local tar_args=${2:-'-xzf'}

    tar ${tar_args} ${file} \
        && rm ${file}
}

source ~/scripts/remote-pi.completion

source /usr/share/git/git-prompt.sh > /dev/null 2>&1
PS1="$(generate_prompt $?)"
