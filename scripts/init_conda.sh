# NOTE: change path to your Conda installation
if [ ! -f /home/esoptron/miniconda3/bin/conda ]; then
    echo "Error: Please first edit your user name and conda installation folder in this script"
    return -1
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/esoptron/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/esoptron/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/esoptron/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/esoptron/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
