source ./init_workspace.sh
source ./ucoslam-config.sh


$UCOSLAM_BIN_DIR/ucoslam_ros \
  -mode STEREO \
  -rosTopic /${CAMERA_NAME}_zed_node/left/image_rect_color \
  -rosEncoding mono8 \
  -rosTopicAlt /${CAMERA_NAME}_zed_node/right/image_rect_color \
  -rosEncodingAlt mono8 \
  -calib $UCOSLAM_CONFIG_DIR/calib_zedm.yml \
  -rectified_input \
  -params $UCOSLAM_CONFIG_DIR/default_params.yml \
  -voc $ORB_VOCABULARY \
  -ros_node_name ${CAMERA_NAME}_ucoslam_node \
  -rosTopicPose ${CAMERA_NAME}/ucoslam_pose \
  -child_frame ${CAMERA_NAME}_link \
  -parent_frame ${CAMERA_NAME}_odometry_frame
  # \
  #-map world.map \
  #-loc_only

#  -sequential \
#  -outvideo "world_out.avi"

# TODO: is ros_node_name necessary?
