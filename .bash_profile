
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/staylor/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/staylor/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/staylor/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/staylor/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export PATH=/Users/staylor/bin:$PATH

[[ -e "/Users/staylor/lib/oracle-cli/lib/python3.11/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "/Users/staylor/lib/oracle-cli/lib/python3.11/site-packages/oci_cli/bin/oci_autocomplete.sh"
