extends Node2D

@onready var camera2D: Camera2D = $Camera2D

var transitioning: bool = false

func _ready() -> void:
	pass
	# camera2D.current = false

func switch_camera(_from, to) -> void:
	# from.current = false
	# to.current = true
	to.make_current()

func transition_camera2D(from: Camera2D, to: Camera2D, duration: float = 1.0) -> void:
	if transitioning: return
	# Copy the parameters of the first camera
	camera2D.zoom = from.zoom
	camera2D.offset = from.offset
	camera2D.light_mask = from.light_mask
	
	# Move our transition camera to the first camera position
	camera2D.global_transform = from.global_transform
	
	# Make our transition camera current
	camera2D.enabled = true
	camera2D.make_current()
	
	transitioning = true
	
	# Move to the second camera, while also adjusting the parameters to
	# match the second camera

	var tween = get_tree().create_tween()

	# tween.remove_all()
	# , Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	tween.tween_property(camera2D, "global_transform", to.global_transform, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera2D, "zoom", to.zoom, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera2D, "offset", to.offset, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.play()
	
	# Wait for the tween to complete
	await tween.finished
	
	# Make the second camera current
	to.enabled = true
	to.make_current()
	transitioning = false

