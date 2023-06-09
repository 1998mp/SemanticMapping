source ./init_workspace.sh
source ./ucoslam-config.sh
# TODO: try these parameters from David:
#  -rosTopic /esoptron_laptop/color/image_rect_color \
#  -rosEncoding bgr8 \
#  -rosTopicAlt /esoptron_laptop/depth/image_rect_raw \
#  -rosEncodingAlt 16SC1 \
# TODO: check whether -rectified_input does anything in RGBD mode. Check what distortion is in he 435i config file

$UCOSLAM_BIN_DIR/ucoslam_ros \
  -mode RGBD \
  -rosTopic /${CAMERA_NAME}/color/image_raw \
  -rosEncoding bgr8 \
  -rosTopicAlt /${CAMERA_NAME}/depth/image_rect_raw \
  -rosEncodingAlt 16UC1 \
  -calib $UCOSLAM_CONFIG_DIR/calib_rsd435i.yml \
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


# possible topics:
# /camera/color/image_raw
# /camera/color/image_raw/compressed
# /camera/color/image_raw/compressedDepth
# /camera/depth/image_rect_raw
# /camera/depth/image_rect_raw/compressed
# /camera/depth/image_rect_raw/compressedDepth
