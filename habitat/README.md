# AiHabitat simulated experiments

Testing our pipeline on a simulation with ground truth dataset and virtual sensors.
We make use of [Habitat-Sim](https://github.com/facebookresearch/habitat-sim) for Rendering sensor measurement of the Replica dataset and [Habitat-Lab](https://github.com/facebookresearch/habitat-lab) for generated noise models.

## Installation

Update Aptitude packages:
```
sudo apt update
sudo apt upgrade
sudo apt autoremove
sudo apt-get install -y --no-install-recommends \
     libjpeg-dev libglm-dev libgl1-mesa-glx libegl1-mesa-dev mesa-utils xorg-dev freeglut3-dev
```

Install anaconda or miniconda
https://docs.conda.io/en/latest/miniconda.html


Choose a directory for the source code:
```
mkdir -p $HOME/dev/habitat
cd $HOME/dev/habitat
```

We provide a setup script `setup.sh` for a conda environment that includes the Habitat simulation engine and interfacing libraries wit other ROS components. Be sure that you have all git submodules initialized and updated, then execute:

WARNING: make sure that ROS is not available on the `echo $PATH`, and that you are in the `base` anaconda environment.
```
cd <SEMANTIC_MAPPING_ROOT>/habitat
export HABITAT_ROOT=$(pwd)
source setup.sh
```

We are going to use the same catkin workspace for communication with ROS that we have previously created in `kimera_ws`. In that workspace, the Python path is already modified to use Python 3, and the `tf2_ros` node got built with python3. // WARNING: but the python3 of the conda environment `semantic_mapping` and not the python3 of the conda environment `habitat` -- this is incorrect and the two environments should be merged instead. But it works now...
If you do not want to use the (arguably very complex) `kimera_ws` workspace, then you need to build `tf2_ros` (part of `geometry2` package) in a separate workspace that uses python3.


## Matterport3D dataset
Use the following script to download the Matterport3D data: http://kaldir.vc.in.tum.de/matterport/download_mp.py. 
Scan data is named by a house hash id. The list of house hash ids is at http://kaldir.vc.in.tum.de/matterport/v1/scans.txt 
Script usage:
- To download the entire Matterport3D release (1.3TB): download-mp.py -o [directory in which to download] 
- To download a specific scan (e.g., 17DRP5sb8fy): download-mp.py -o [directory in which to download] --id 17DRP5sb8fy
- To download a specific file type (e.g., *.sens, valid file suffixes listed here): download-mp.py -o [directory in which to download] --type .sens
- *.sens files can be read using the sens-File reader (it's a bit easier to handle than a larger number of separate image files)
Example:
```
python download-mp.py -o $HOME/data/mp3d --id 17DRP5sb8fy
```
WARNING: the `download_mp.py` script is written for python2. If you have python3, you need to replace these lines:
```
raw_input() --> input()
print msg --> print(msg)
```
Next, download the extra files for the habitat task (http://kaldir.vc.in.tum.de/matterport/v1/tasks//mp3d_habitat.zip):
```
python download-mp.py -o $HOME/data/mp3d --id 17DRP5sb8fy --task_data habitat
```


## Replica dataset

- Download the Replica dataset as described [here](https://github.com/facebookresearch/Replica-Dataset).
   To work with the Replica dataset, you need a file called `sorted_faces.bin` for each model. 
   Such files (1 file per model), along with a convenient setup script can be downloaded from here: [sorted_faces.zip](http://dl.fbaipublicfiles.com/habitat/sorted_faces.zip). You need:

- Download the zip file from the above link - *Note: Expect aroung 80Gb of Data.... :(*
- Unzip it to any location with given path and locate the *sorted_faces* folder.
- Here run  `source copy_to_folders <Replica root directory. e.g ~/models/replica/>` which copies semantic description to the scene folders


## Running the experiment

In Terminal 1, start roscore (no conda environment):
```
conda deactivate
cd <SEMANTIC_MAPPING_ROOT>/scripts
source init_workspace.sh
roscore
```

In a fresh Terminal 2, activate the Catkin workspace and _after that_ activate the Conda environment:
```
conda deactivate
cd <SEMANTIC_MAPPING_ROOT>/scripts
source init_workspace.sh
conda activate habitat
```

and run our Habitat to ROS Python node with a Replica scene:
```
cd <SEMANTIC_MAPPING_ROOT>/habitat/habitat_interface
python traj_sim.py \
    --mesh_path $HOME/data/replica/room_0/habitat/mesh_semantic.ply \
    --publish_tf True \
    --write_bag True
```

Move around with the arrow keys in the white control window. Press ESC to exit. Finally, check the contents of the output rosbag in the data folder: `rosbag info output.bag`

WARNING an error about missing `tf2_ros` (PyInit__tf2) appears when the `init_workspace.sh` is called while a conda environment is active, because the ROS setup script messes up something with the paths, and tries to use the default `tf2_ros` which was built python2 instead of the `tf2_ros` in our `kimera_ws` which was built with python3.


## Parameters to set

Change parameters for semantic mesh, topic names and etc in file `traj_sim.py`. 
All argument possible given to the python script are listed here with default values


```
--mesh_path, default=/home/esoptron/data/Replica/frl_apartment_4/habitat/mesh_semantic.ply,  
                    help=The Replica mesh path mesh, that provides the model for simulation
--camera_config, default=../config/calib_k4a.yml,
                    help=The camera parameters of the virtual camera that simulates the image
--robot_frame, default=habitat_robot_base,
                    help=The frame of the robot sensor, where the camera pose is tracked
--parent_frame, default="habitat_odometry_frame",
                    help=The world or the odometry frame, where we get the sensor frame. 
                         Should be aligned to the mesh
--image_topic_name, default=/habitat/rgb/image_raw,
                    help=The images will be savd under this topic
--depth_topic_name, default="/habitat/depth/image_raw",
                    help=The depth images will be saved under this topic
--semantic_topic_name, default=/habitat/semantics/image_raw,
                    help=The semantic imaes will be saved under this topic

--compressed_image_topic_name, default=/habitat/rgb/image_raw/compressed,
                    help=The compressed images will be savd under this topic
--compressed_depth_topic_name, default="/habitat/depth/image_raw/compressedDepth",
                    help=The compressed depth images will be saved under this topic
--compressed_semantic_topic_name, default=/habitat/semantics/image_raw/compressed,
                    help=The compressed semantic images will be saved under this topic
--output_bag_name,  default="../data/output.bag",
                    help=The name and relative path of the output bag file
--output_agent_pose_name, default="../data/agent_states.npy",
                    help=The name and relative path of the output agent pose file
--target_fps,       default=5,
                    help=The number of frames to render per second
--compressed,       default=False,
                    help=To compress images saved to rosbag
--replay_mode,      default=False,
                    help=To replay recorded trajectory from numpy array of poses
--gaussian_sigma,   default=0.5,
                    help=Sigma of the Gaussian blur
--motion_blur_weight, default=1,
                    help=Weighting of the motion blur
--write_bag,        default=False,
                    help='To compress images saved to rosbag
--publish_tf,       default=True,
                    help='To publish and save the TF tree
```

