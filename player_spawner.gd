extends Node

@export var mage: CharacterData
@export var warrior: CharacterData

@onready var character_scene: PackedScene = preload("res://character.tscn")

@onready var player_a_position_a: MeshInstance3D = get_owner().get_node('Scenario/PlayerAPositions/A')
@onready var player_a_position_b: MeshInstance3D = get_owner().get_node('Scenario/PlayerAPositions/B')
@onready var player_a_position_c: MeshInstance3D = get_owner().get_node('Scenario/PlayerAPositions/C')
@onready var player_b_position_a: MeshInstance3D = get_owner().get_node('Scenario/PlayerBPositions/A')
@onready var player_b_position_b: MeshInstance3D = get_owner().get_node('Scenario/PlayerBPositions/B')
@onready var player_b_position_c: MeshInstance3D = get_owner().get_node('Scenario/PlayerBPositions/C')


func _ready():
	_hide_debug_positions()
	spawn_player_a_characters()
	spawn_player_b_characters()
	TurnManager.start_battle()


func _spawn_player_character(character_data: CharacterData, position: Vector3, name_char: String):
	var character_instance: Node3D = character_scene.instantiate()
	if character_instance is Character:
		character_instance.initialize_character(character_data, name_char)
		character_instance.transform.origin = position - Vector3(0, 1, 0)
		call_deferred("add_child", character_instance)
		TurnManager.register_character.emit(character_instance)
		character_instance.register_character_in_turn_manager()
	else:
		push_error("The instantiated scene is not a Character instance.")


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
