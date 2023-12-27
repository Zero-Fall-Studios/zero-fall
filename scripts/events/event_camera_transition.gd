class_name EventCameraTransition
extends Event

@export var camera1 : Camera2D
@export var camera2 : Camera2D

func run():
  CameraTransition.transition_camera2D(camera1, camera2)
  await super.run()
