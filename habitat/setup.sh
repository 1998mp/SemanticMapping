#!/bin/bash

# read more here: 
# https://github.com/facebookresearch/habitat-lab
# https://github.com/facebookresearch/habitat-sim
# (note that if you use a specific version, then read the README.md belonging to that git tag!)

export HABITAT_ROOT=$(pwd)

conda create -n habitat python=3.7 cmake=3.14.0
conda activate habitat


cd $HABITAT_ROOT/habitat-sim
pip install -r requirements.txt


cd $HABITAT_ROOT/habitat-lab
pip install -r ./requirements.txt
reqs=(./habitat_baselines/**/requirements.txt) # optional
pip install "${reqs[@]/#/-r}" # optional, takes a lot of time...
python setup.py develop --all
pip install .
# ^ Reinstall to trigger sys.path update


cd $HABITAT_ROOT/habitat-sim
conda install habitat-sim -c conda-forge -c aihabitat


# Additional dependencies for exporting from Habitat to ROS
conda install pycryptodomex
conda install scikit-image
conda install -c conda-forge python-gnupg
conda install -c conda-forge rospkg


mkdir -p output

cd $HABITAT_ROOT/habitat_interface

