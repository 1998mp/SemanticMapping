source ./init_workspace.sh

ROBOT_NAME=${HOSTNAME}
if [ "$#" -ne 1 ]; then
    ROBOT_NAME=${HOSTNAME}
    echo "Running semantic mapping from source robot: $ROBOT_NAME"
else
    ROBOT_NAME=$1
    echo "Running semantic mapping from source robot: $ROBOT_NAME"
fi

roslaunch \
  kimera_interface \
  ucoslam_zed_semantic.launch \
  robot_hostname:=${ROBOT_NAME} \
  metric_semantic_reconstruction:=false \
  rgb_encoding:=raw \
  depth_encoding:=raw \
  left_cam_info_topic:=/${ROBOT_NAME}_zed_node/left/camera_info \
  left_cam_topic:=/${ROBOT_NAME}_zed_node/left/image_rect_color \
  left_cam_depth_topic:=/${ROBOT_NAME}_zed_node/depth/depth_registered \
  left_cam_segmentation_topic:=/semantics/semantic_image \
  semantic_pointcloud:=/semantics/semantic_cloud



