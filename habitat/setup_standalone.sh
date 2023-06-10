# NOTE: you only need this script if you do not want to use our `semantic_mapping` conda environment. 
# The first part describes how to install habitat, the second part describes how to connect it with ROS

# *** Part 1: habitat ***

# modify this variable:
export HABITAT_ROOT=$HOME/dev/habitat
export HABITAT_CONDA_ENV_NAME=habitat

# update Aptitude packages
sudo apt update
sudo apt upgrade
sudo apt autoremove

sudo apt-get install -y --no-install-recommends \
     libjpeg-dev libglm-dev libgl1-mesa-glx libegl1-mesa-dev mesa-utils xorg-dev freeglut3-dev


# create conda environment
conda create -n $HABITAT_CONDA_ENV_NAME python=3.7 cmake=3.14.0
# activate conda environment
conda activate $HABITAT_CONDA_ENV_NAME


mkdir -p $HABITAT_ROOT
cd $HABITAT_ROOT

# clone habitat-lab
git clone --branch stable https://github.com/facebookresearch/habitat-lab.git
# (or pull):
cd $HABITAT_ROOT/habitat-lab
git checkout main
git pull
git checkout stable

# update the submodules:
cd $HABITAT_ROOT/habitat-lab
git submodule update --init --recursive

# install habitat-lab
pip install -r requirements.txt
reqs=(./habitat_baselines/**/requirements.txt)
pip install "${reqs[@]/#/-r}"
python setup.py develop --all
pip install .
# ^ Reinstall to trigger sys.path update


# install habitat-sim with bullet physics (available as conda package)
conda install habitat-sim withbullet -c conda-forge -c aihabitat

# also get the code of habitat-sim to have the examples
cd $HABITAT_ROOT
git clone --branch stable https://github.com/facebookresearch/habitat-sim.git
cd $HABITAT_ROOT/habitat-sim
git submodule update --init --recursive

# download some test data
python -m habitat_sim.utils.datasets_download --uids habitat_test_scenes --data-path $HOME/data/habitat

# test it:
cd $HOME/dev/habitat/habitat-sim
habitat-viewer $HOME/data/habitat/scene_datasets/habitat-test-scenes/skokloster-castle.glb



# *** Part 2: connecting habitat with ROS ***
# On Ubuntu 18, the TF2 package must be rebuilt with Python3

# set HABITAT_ROOT and HABITAT_CONDA_ENV_NAME as above
export HABITAT_ROOT=$HOME/dev/habitat
export HABITAT_CONDA_ENV_NAME=habitat
export MY_CONDA_PATH=$HOME/anaconda3
# for me, this is: export MY_CONDA_PATH=$HOME/miniconda3
export MY_CONDA_ENV_NAME=$HABITAT_CONDA_ENV_NAME

# activate our conda environment
conda activate $HABITAT_CONDA_ENV_NAME

# install the ROS dependencies for the conda environment
conda install pycryptodomex
conda install scikit-image
conda install -c conda-forge python-gnupg
conda install -c conda-forge rospkg catkin_pkg

# deactivate all conda environments (even base!!!)
conda deactivate
conda deactivate
# (rather open a fresh Terminal)


# initialize a new catkin workspace (extending the basic melodic workspace)
mkdir -p $HABITAT_ROOT/habitat_ws
cd $HABITAT_ROOT/habitat_ws
source /opt/ros/melodic/setup.bash
mkdir src
catkin init

# Configure this workspace to use the Python from our conda environment
# make sure to adjust your python version below -- my version is 3.7
catkin config --cmake-args \
    -DCMAKE_BUILD_TYPE=Release \
    -DPYTHON_EXECUTABLE=$MY_CONDA_PATH/envs/$MY_CONDA_ENV_NAME/bin/python3 \
    -DPYTHON_INCLUDE_DIR=$MY_CONDA_PATH/envs/$MY_CONDA_ENV_NAME/include/python3.7m \
    -DPYTHON_LIBRARY=$MY_CONDA_PATH/envs/$MY_CONDA_ENV_NAME/lib/libpython3.7m.so
catkin config --merge-devel
catkin config --extend /opt/ros/melodic

# build empty workspace just to trigger the creation of devel/setup.sh
catkin build




source $HABITAT_ROOT/habitat_ws/devel/setup.bash

# clone and build the geometry2 package
cd $HABITAT_ROOT/habitat_ws/src
git clone --branch melodic-devel https://github.com/ros/geometry2.git
cd $HABITAT_ROOT/habitat_ws
catkin build


# test our habitat-ROS script as described in $SEMANTIC_MAPPING_ROOT/habitat/README
# Open a fresh Terminal
source $HABITAT_ROOT/habitat_ws/devel/setup.bash

conda activate $HABITAT_CONDA_ENV_NAME

cd $SEMANTIC_MAPPING_ROOT/habitat/habitat_interface
python traj_sim.py \
    --mesh_path $HOME/data/replica/room_0/habitat/mesh_semantic.ply \
    --publish_tf True \
    --write_bag True

