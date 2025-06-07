extends Node

@onready var camera3D: Camera3D = $Camera

signal camera_started_transition
signal camera_finished_transition

var transitioning: bool = false

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

	await tween.finished

	to.current = true
	transitioning = false
	camera_finished_transition.emit()
