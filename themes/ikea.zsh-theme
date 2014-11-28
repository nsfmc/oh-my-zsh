
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

function hg_prompt_info {
    hg prompt --angle-brackets "\
< on %{$fg[green]%}<branch|quiet>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[orange]%}>%{$reset_color%}>\
< at %{$fg[green]%}<bookmark>%{$reset_color%}>\
%{$fg[blue]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied()|post_unapplied()>>" 2>/dev/null
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function nodeenv_info {
    [ $NODE_VIRTUAL_ENV ] && echo '{'`basename $NODE_VIRTUAL_ENV`'} '
}

function wwdiff () {
  if [[ -f $1 && -f $2 ]]; then
    echo $1;
    echo $2;
    wdiff -n\
    -w $'\033[30;31m\033[4m' -x $'\033[0m'\
    -y $'\033[30;32m' -z $'\033[0m'\
    $1 $2 | less -R
  fi
}

function wo () {
  # work on a virtualenv, defaults to activating
  # ./env/bin/activate but will do
  # $1/bin/activate
  local ENV_PATH=${1-"env"}
  source "${ENV_PATH}/bin/activate"
}

function motd () {
    if [ -e ~/.motd.txt ]; then
        local rnd=1
        fn=~/.motd.txt
        lns=$(wc -l $fn | sed 's|[ ]*\([0-9]*\).*|\1|')
        if [ "$lns" = 0 ]; then
          rnd=1
        else
          rnd=$(( (RANDOM % (lns + 1)) + 1 ))
        fi
        sed -n ${rnd}p $fn
    fi
}

function upgrade_datastore () {
    local ds_source="${HOME}/Dropbox (Khan Academy)/Khan Academy All Staff/Other shared items/datastores"
    local ds_target="${HOME}/projects/.gae"
    local backup_name="current.sqlite $(date "+%Y-%m-%d %H.%M.%S")"
    mv "${ds_target}/current.sqlite" "${ds_target}/${backup_name}"
    cp "${ds_source}/current.sqlite" "${ds_target}/"
    echo "Copied new current.sqlite from dropbox"
    echo "Your old current.sqlite has been archived at "
    echo "  ${fg[yellow]}${ds_target}/${backup_name}"
}

PROMPT='
%{$fg[blue]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%} in %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
$(virtualenv_info)$(nodeenv_info)$(prompt_char) '

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
