extends Node3D
class_name Character

@export var character_data: CharacterClassData

@export var name_character: String = "Character"
@export var name_class: String = "Class"
@export var description: String = "A character in the game."
@export var skill_points: int = 0
@export var health: int = 0
@export var attack: int = 0
@export var defense: int = 0
@export var speed: int = 0
@export var magic: int = 0
@export var luck: int = 0
@export var experience: int = 0
@export var critical_chance: float = 0.0
@export var level: int = 1
@export var color: Color = Color(1, 1, 1)

var _is_turn: bool = false


func _on_turn_started(character: Character):
	if character.name_character == self.name_character:
		if _is_turn: return
		_is_turn = true
		_change_color(Color(1, 1, 0))
	else:
		_is_turn = false
		_change_color(color)


func initialize_character(class_data: CharacterClassData, name_char: String):
	if class_data:
		name_character = name_char
		name_class = class_data.name
		description = class_data.description
		skill_points = class_data.skill_points
		health = class_data.health
		attack = class_data.attack
		defense = class_data.defense
		speed = class_data.speed
		magic = class_data.magic
		luck = class_data.luck
		experience = class_data.experience
		critical_chance = class_data.critical_chance
		level = class_data.level
		color = class_data.color
		_change_color(color)


func _change_color(new_color: Color):
	if is_instance_valid(get_node("MeshInstance3D")):
		var mesh_instance: MeshInstance3D = get_node("MeshInstance3D")
		var material: StandardMaterial3D = StandardMaterial3D.new()
		material.albedo_color = new_color
		mesh_instance.set_surface_override_material(0, material)


func init_signals():
	TurnManager.turn_started.connect(_on_turn_started)