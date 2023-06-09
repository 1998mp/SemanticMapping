source ./init_workspace.sh
source ./ucoslam-config.sh

$UCOSLAM_BIN_DIR/ucoslam_ros \
  -mode RGBD \
  -rosTopic /rgb/image_raw \
  -rosEncoding bgr8 \
  -rosTopicAlt /depth_to_rgb/image_raw \
  -rosEncodingAlt 16UC1 \
  -depth_scale 0.001 \
  -calib $UCOSLAM_CONFIG_DIR/calib_k4a.yml \
  -params $UCOSLAM_CONFIG_DIR/default_params.yml \
  -voc $ORB_VOCABULARY \
  -ros_node_name ${CAMERA_NAME}_ucoslam_node \
  -rosTopicPose ${CAMERA_NAME}/ucoslam_pose \
  -child_frame ${CAMERA_NAME}_camera_base \
  -parent_frame ${CAMERA_NAME}_odometry_frame 
  #\
  #-map world.map \
  #-loc_only

#  -sequential \
#  -outvideo "world_out.avi"

# WARNING: depth in 16UC1 format is in millimeters, but depth in 32FC1 format is in meters! 
# Make sure that the depth scale must be consistent in your pipeline.
# see https://github.com/microsoft/Azure_Kinect_ROS_Driver/commit/ea70ccf 

# possible topics:
#/rgb/camera_info
#/rgb/image_raw
#/rgb/image_raw/compressed
#/depth_to_rgb/camera_info
#/depth_to_rgb/image_raw
#/depth_to_rgb/image_raw/compressed
