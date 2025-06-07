extends Node3D
class_name Character

@export var character_class_data: CharacterClassData

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

func _input(event):
	if not _is_turn: return

	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_A:
		CameraTransition.transition_camera3D(
			get_node("Camera3D"),
			TurnManager.get_next_turn_character().get_node("CameraTargetAttack")
		)


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

	
func _on_turn_started(character: Character):
	if character._character_data['name'] == self._character_data['name']:
		if _is_turn: return
		_is_turn = true
		_change_color(Color(1, 1, 0))
	else:
		_is_turn = false
		_change_color(_character_data['class_data']['color'])


# --- UTIlS --- #
	
func _change_color(new_color: Color):
	if is_instance_valid(get_node("MeshInstance3D")):
		var mesh_instance: MeshInstance3D = get_node("MeshInstance3D")
		var material: StandardMaterial3D = StandardMaterial3D.new()
		material.albedo_color = new_color
		mesh_instance.set_surface_override_material(0, material)
