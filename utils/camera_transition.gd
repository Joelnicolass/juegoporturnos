extends Node

@onready var transition_camera: Camera3D = $Camera

signal camera_started_transition
signal camera_finished_transition

var transitioning: bool = false
var _current_camera: Camera3D = null


func _ready() -> void:
	transition_camera.current = false


func switch_camera(from, to) -> void:
	from.current = false
	to.current = true


func transition_camera3D(from: Camera3D, to: Camera3D, duration: float = 0.5) -> void:
	if transitioning: return
	camera_started_transition.emit()
	
	transition_camera.fov = from.fov
	transition_camera.cull_mask = from.cull_mask
	transition_camera.global_transform = from.global_transform

	var transition_camera_atr = transition_camera.attributes
	var from_atr = from.attributes
	var to_atr = to.attributes
	
	transition_camera.current = true
	transitioning = true

	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(transition_camera, "global_transform", to.global_transform, duration).from(transition_camera.global_transform)
	tween.tween_property(transition_camera, "fov", to.fov, duration).from(transition_camera.fov)

	# TODO -> Implement a system to manage the depth of field blur.
	#if to_atr.get('dof_blur_far_enabled'):
	#	transition_camera.attributes.set('dof_blur_far_enabled', true)
	#	transition_camera.attributes.set('dof_blur_far_distance', 200.0)

	#	tween.tween_property(transition_camera.attributes, "dof_blur_far_distance", to.attributes.get('dof_blur_far_distance'), duration).from(transition_camera.attributes.get('dof_blur_far_distance'))
	
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
