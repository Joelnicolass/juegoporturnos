extends Node

@onready var camera3D: Camera3D = $Camera

signal camera_started_transition
signal camera_finished_transition

var transitioning: bool = false
var _current_camera: Camera3D = null


func _ready() -> void:
	camera3D.current = false


func switch_camera(from, to) -> void:
	from.current = false
	to.current = true


func transition_camera3D(from: Camera3D, to: Camera3D, duration: float = 0.5) -> void:
	if transitioning: return
	camera_started_transition.emit()
	
	camera3D.fov = from.fov
	camera3D.cull_mask = from.cull_mask
	camera3D.global_transform = from.global_transform
	
	camera3D.current = true
	transitioning = true

	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera3D, "global_transform", to.global_transform, duration).from(camera3D.global_transform)
	tween.tween_property(camera3D, "fov", to.fov, duration).from(camera3D.fov)

	var camera_atr = camera3D.attributes
	var to_atr = to.attributes
	print(camera_atr.get('dof_blur_far_enabled'))
	print(to_atr.get('dof_blur_far_enabled'))

	# TODO -> Implement a system to manage the depth of field blur.
	if to_atr.get('dof_blur_far_enabled'):
		camera3D.attributes.set('dof_blur_far_enabled', true)
		camera3D.attributes.set('dof_blur_far_distance', 200.0)

		tween.tween_property(camera3D.attributes, "dof_blur_far_distance", to.attributes.get('dof_blur_far_distance'), duration).from(camera3D.attributes.get('dof_blur_far_distance'))
		

	await tween.finished

	to.current = true
	transitioning = false
	_current_camera = to

	camera_finished_transition.emit()


func get_current_camera() -> Camera3D:
	if _current_camera:
		return _current_camera
	else:
		return get_viewport().get_camera_3d()
