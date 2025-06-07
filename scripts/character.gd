extends Node3D
class_name Character

@export var character_class_data: CharacterClassData

enum Team {
	PLAYER,
	ENEMY
}

var _character_data: Dictionary = {
	'name': null,
	'team': null,
	'class_data': {
		'name': 'No Class',
		'description': 'No description available.',
		'skill_points': 0,
		'health': 0.0,
		'attack': 0.0,
		'defense': 0.0,
		'speed': 0.0,
		'magic': 0.0,
		'luck': 0.0,
		'experience': 0.0,
		'critical_chance': 0.0,
		'level': 1,
		'color': Color(1, 1, 1),
	},
}


var _is_turn: bool = false


# --- HANDLERS --- #

var enemies: Array[Character] = []
var _is_attacking: bool = false
var _index_enemy_attack: int = 0

# TODO -> Implement a system to manage the attack and damage calculation.
# TODO -> This is a placeholder for the attack logic.

func _input(event):
	if not _is_turn: return
	if _character_data['team'] != str(Team.PLAYER): return

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_A and not _is_attacking:
		_is_attacking = true

		enemies = TurnManager.get_battle_characters().filter(func(character: Character) -> bool:
			return character.get_team() != str(Team.PLAYER)
		)

		CameraTransition.transition_camera3D(
			get_node("Camera3D"),
			enemies[_index_enemy_attack].get_node("CameraTargetAttack"),
			1.0
		)

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_LEFT and not CameraTransition.transitioning:
		if _is_attacking and enemies.size() > 0:
			var next_index: int = _index_enemy_attack - 1
			if next_index >= enemies.size() or next_index < 0:
				next_index = enemies.size() - 1
			_index_enemy_attack = next_index

			CameraTransition.transition_camera3D(
				CameraTransition.get_current_camera(),
				enemies[_index_enemy_attack].get_node("CameraTargetAttack"),
			)

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_RIGHT and not CameraTransition.transitioning:
		if _is_attacking and enemies.size() > 0:
			var next_index: int = _index_enemy_attack + 1
			if next_index >= enemies.size():
				next_index = 0
			_index_enemy_attack = next_index

			CameraTransition.transition_camera3D(
				CameraTransition.get_current_camera(),
				enemies[_index_enemy_attack].get_node("CameraTargetAttack"),
			)

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE and _is_attacking:
		_is_attacking = false
		CameraTransition.transition_camera3D(
			CameraTransition.get_current_camera(),
			get_node("Camera3D"),
			1.0
		)
		_index_enemy_attack = 0


# --- PUBLIC METHODS --- #

func initialize_character(name_character: String, team: String, class_data: CharacterClassData):
	_character_data['name'] = name_character
	_character_data['team'] = team
	_character_data['class_data'] = class_data
	_init_signals()


func get_character_data() -> Dictionary:
	return _character_data


func get_character_class_data() -> CharacterClassData:
	return _character_data['class_data']


func get_class_data_parameter(parameter: String) -> Variant:
	if parameter in _character_data['class_data']:
		return _character_data['class_data'][parameter]
	else:
		push_error("Parameter not found in character data class: " + parameter)
		return null


func set_team(team: String):
	_character_data['team'] = team


func get_team() -> String:
	return _character_data['team']


# --- PRIVATE METHODS --- #

func _init_signals():
	TurnManager.turn_started.connect(_on_turn_started)
	TurnManager.turn_ended.connect(_on_turn_ended)

	
func _on_turn_started(character: Character):
	if character._character_data['name'] == self._character_data['name']:
		if _is_turn: return
		_is_turn = true
		_change_color(Color(1, 1, 0))
	else:
		_is_turn = false
		_change_color(_character_data['class_data']['color'])


func _on_turn_ended(_character: Character):
	if not _is_turn:
		_is_attacking = false
		_index_enemy_attack = 0
		enemies.clear()


# --- UTIlS --- #
	
func _change_color(new_color: Color):
	if is_instance_valid(get_node("MeshInstance3D")):
		var mesh_instance: MeshInstance3D = get_node("MeshInstance3D")
		var material: StandardMaterial3D = StandardMaterial3D.new()
		material.albedo_color = new_color
		mesh_instance.set_surface_override_material(0, material)
