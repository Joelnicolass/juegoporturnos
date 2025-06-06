extends Node

@export var mage: CharacterClassData
@export var warrior: CharacterClassData

@onready var character_scene: PackedScene = preload("res://character.tscn")

@onready var player_a_position_a: MeshInstance3D = get_owner().get_node('Scenario/PlayerAPositions/A')
@onready var player_a_position_b: MeshInstance3D = get_owner().get_node('Scenario/PlayerAPositions/B')
@onready var player_a_position_c: MeshInstance3D = get_owner().get_node('Scenario/PlayerAPositions/C')
@onready var player_b_position_a: MeshInstance3D = get_owner().get_node('Scenario/PlayerBPositions/A')
@onready var player_b_position_b: MeshInstance3D = get_owner().get_node('Scenario/PlayerBPositions/B')
@onready var player_b_position_c: MeshInstance3D = get_owner().get_node('Scenario/PlayerBPositions/C')

@onready var cameraA: Camera3D = get_owner().get_node('Scenario/CameraA')
@onready var cameraB: Camera3D = get_owner().get_node('Scenario/CameraB')


func _ready():
	_hide_debug_positions()
	spawn_player_a_characters()
	spawn_player_b_characters()
	TurnManager.start_battle.emit()


func _spawn_player_character(character_class_data: CharacterClassData, position: Vector3, name_char: String):
	var character_instance: Node3D = character_scene.instantiate()
	if character_instance is Character:
		character_instance.initialize_character(character_class_data, name_char)
		character_instance.transform.origin = position - Vector3(0, 1, 0)
		call_deferred("add_child", character_instance)
		TurnManager.register_character.emit(character_instance)
		character_instance.init_signals()


func _hide_debug_positions():
	player_a_position_a.visible = false
	player_a_position_b.visible = false
	player_a_position_c.visible = false
	player_b_position_a.visible = false
	player_b_position_b.visible = false
	player_b_position_c.visible = false


func spawn_player_a_characters():
	_spawn_player_character(mage, player_a_position_a.global_transform.origin, "Player A Mage")
	_spawn_player_character(warrior, player_a_position_b.global_transform.origin, "Player A Warrior")
	_spawn_player_character(mage, player_a_position_c.global_transform.origin, "Player A Mage 2")


func spawn_player_b_characters():
	_spawn_player_character(mage, player_b_position_a.global_transform.origin, "Player B Mage")
	_spawn_player_character(warrior, player_b_position_b.global_transform.origin, "Player B Warrior")
	_spawn_player_character(mage, player_b_position_c.global_transform.origin, "Player B Mage 2")


func _on_next_turn_pressed() -> void:
	TurnManager.turn_ended.emit(TurnManager._turn_order[TurnManager._current_turn_index])
	_change_camera()

func _change_camera() -> void:
	if cameraA.current:
		CameraTransition.transition_camera3D(cameraA, cameraB)
	else:
		CameraTransition.transition_camera3D(cameraB, cameraA)
