#!/bin/bash
CUR_SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
echo "initializing /opt/ros/melodic"
source /opt/ros/melodic/setup.bash
echo "initializing $CUR_SCRIPT_DIR/../kimera_ws/devel"
source $CUR_SCRIPT_DIR/../kimera_ws/devel/setup.bash
echo PATH:  $PATH
