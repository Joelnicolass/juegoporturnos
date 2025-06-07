extends Node

@export var mage: CharacterClassData
@export var warrior: CharacterClassData

@onready var character_scene: PackedScene = preload("res://scenes/character.tscn")

@onready var player_a_position_a: MeshInstance3D = get_owner().get_node('Scenario/PlayerAPositions/A')
@onready var player_a_position_b: MeshInstance3D = get_owner().get_node('Scenario/PlayerAPositions/B')
@onready var player_a_position_c: MeshInstance3D = get_owner().get_node('Scenario/PlayerAPositions/C')
@onready var player_b_position_a: MeshInstance3D = get_owner().get_node('Scenario/PlayerBPositions/A')
@onready var player_b_position_b: MeshInstance3D = get_owner().get_node('Scenario/PlayerBPositions/B')
@onready var player_b_position_c: MeshInstance3D = get_owner().get_node('Scenario/PlayerBPositions/C')

@onready var enemy_turn_camera: Camera3D = get_owner().get_node('Scenario/EnemyTurnCamera')
@onready var btn_next_turn: Button = get_owner().get_node('UI/Control/NextTurn')


enum Team {
	PLAYER,
	ENEMY
}

func _ready():
	CameraTransition.camera_started_transition.connect(_on_started_camera_transition)
	CameraTransition.camera_finished_transition.connect(_on_finished_camera_transition)
	TurnManager.start_battle.connect(_on_start_battle)
	_hide_debug_positions()
	spawn_player_a_characters()
	spawn_player_b_characters()
	TurnManager.start_battle.emit()


func _on_started_camera_transition():
	btn_next_turn.disabled = true
	
	
func _on_finished_camera_transition():
	btn_next_turn.disabled = false


func _on_start_battle():
	var initial_character = TurnManager.get_current_turn_character()
	initial_character.get_node("Camera3D").current = true


func _spawn_player_character(name_char: String, team: String, character_class_data: CharacterClassData, position: Vector3, rotation: Vector3):
	var character_instance: Node3D = character_scene.instantiate()
	if character_instance is Character:
		character_instance.initialize_character(name_char, team, character_class_data)
		character_instance.transform.origin = position - Vector3(0, 1, 0)
		character_instance.rotation = rotation
		call_deferred("add_child", character_instance)
		TurnManager.register_character.emit(character_instance)


func _hide_debug_positions():
	player_a_position_a.visible = false
	player_a_position_b.visible = false
	player_a_position_c.visible = false
	player_b_position_a.visible = false
	player_b_position_b.visible = false
	player_b_position_c.visible = false


func spawn_player_a_characters():
	_spawn_player_character("Player A Mage", str(Team.PLAYER), mage, player_a_position_a.global_transform.origin, player_a_position_a.global_transform.basis.get_euler())
	_spawn_player_character("Player A Warrior", str(Team.PLAYER), warrior, player_a_position_b.global_transform.origin, player_a_position_b.global_transform.basis.get_euler())
	_spawn_player_character("Player A Mage 2", str(Team.PLAYER), mage, player_a_position_c.global_transform.origin, player_a_position_c.global_transform.basis.get_euler())


func spawn_player_b_characters():
	_spawn_player_character("Player B Mage", str(Team.ENEMY), mage, player_b_position_a.global_transform.origin, player_b_position_a.global_transform.basis.get_euler())
	_spawn_player_character("Player B Warrior", str(Team.ENEMY), warrior, player_b_position_b.global_transform.origin, player_b_position_b.global_transform.basis.get_euler())
	_spawn_player_character("Player B Mage 2", str(Team.ENEMY), mage, player_b_position_c.global_transform.origin, player_b_position_c.global_transform.basis.get_euler())


func _on_next_turn_pressed() -> void:
	var current_turn_character: Character = TurnManager.get_current_turn_character()
	var next_turn_character: Character = TurnManager.get_next_turn_character()

	if next_turn_character.get_team() == str(Team.PLAYER):
		_change_camera(CameraTransition.get_current_camera(), next_turn_character)
	else:
		CameraTransition.transition_camera3D(CameraTransition.get_current_camera(), enemy_turn_camera, 1.0)
	TurnManager.turn_ended.emit(current_turn_character)


func _change_camera(current_cam: Camera3D, to_character: Character) -> void:
	CameraTransition.transition_camera3D(
		current_cam,
		to_character.get_node("Camera3D"),
		1.0
	)
