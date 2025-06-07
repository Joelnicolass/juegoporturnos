extends Node

# TurnManager.gd
# =====================
# Sistema de gestión de turnos para batallas por turnos en Godot.
#
# USO GENERAL:
# 1. Registra los personajes que participarán en la batalla usando el signal `register_character`.
# 2. Cuando todos los personajes estén registrados, inicia la batalla emitiendo el signal `start_battle`.
# 3. El TurnManager ordena los personajes según su velocidad y emite el signal `turn_started` para indicar de quién es el turno.
# 4. Cuando un personaje termina su turno, debe emitir el signal `turn_ended` para avanzar al siguiente turno.
# 5. Puedes consultar el personaje actual, el siguiente, el orden de turnos y los participantes mediante los métodos públicos.
#
# SEÑALES:
# - start_battle(): Inicia la batalla y el ciclo de turnos.
# - register_character(character): Registra un personaje para la batalla.
# - unregister_character(character): Elimina un personaje de la batalla.
# - clean_battle(): Limpia todos los datos de la batalla actual.
# - turn_started(character): Se emite cuando comienza el turno de un personaje.
# - turn_ended(character): Se emite cuando un personaje termina su turno.
#
# MÉTODOS PÚBLICOS:
# - get_current_turn_character(): Devuelve el personaje cuyo turno está activo.
# - get_next_turn_character(): Devuelve el personaje que tendrá el siguiente turno.
# - get_battle_characters(): Devuelve la lista de personajes participantes.
# - get_turn_order(): Devuelve el orden actual de turnos.
# - get_current_turn_index(): Devuelve el índice del turno actual.
#
# NOTAS:
# - El orden de turnos se determina por la velocidad de los personajes (atributo `speed`).
# - Puedes modificar el orden de turnos dinámicamente si algún efecto lo requiere.
# - El sistema es flexible para agregar o quitar personajes durante la batalla.
#
# Ejemplo de uso:
#   TurnManager.register_character.emit(personajeA)
#   TurnManager.register_character.emit(personajeB)
#   TurnManager.register_character.emit(personajeC)
#   TurnManager.start_battle.emit()
#   TurnManager.turn_ended.emit(personajeA)
#   ...
#	TurnManager.clean_battle.emit()
#
# =====================

signal start_battle()
signal register_character(character: Character)
signal unregister_character(character: Character)
signal clean_battle()
signal turn_started(character: Character)
signal turn_ended(character: Character)


var _battle_characters: Array[Character] = []
var _turn_order: Array[Character] = []
var _current_turn_index: int = 0


func _ready():
	start_battle.connect(_on_start_battle)
	register_character.connect(_on_register_character)
	unregister_character.connect(_on_unregister_character)
	clean_battle.connect(_on_clean_battle)
	turn_ended.connect(_on_turn_ended)


# --- PUBLIC METHODS --- #

func get_next_turn_character() -> Character:
	var next_index: int = _current_turn_index + 1
	if next_index >= _turn_order.size():
		next_index = 0
		
	return _turn_order[next_index]
	

func get_current_turn_character() -> Character:
	return _turn_order[_current_turn_index]


func get_battle_characters() -> Array[Character]:
	return _battle_characters.duplicate()


func get_turn_order() -> Array[Character]:
	return _turn_order.duplicate()


func get_current_turn_index() -> int:
	return _current_turn_index


# --- PRIVATE METHODS --- #

func _on_register_character(character: Character):
	if character not in _battle_characters:
		_battle_characters.append(character)


func _on_unregister_character(character: Character):
	if character in _battle_characters:
		_battle_characters.erase(character)
	if character in _turn_order:
		_turn_order.erase(character)


func _on_clean_battle():
	_battle_characters.clear()
	_turn_order.clear()
	_current_turn_index = 0


func _on_start_battle():
	_turn_order = _battle_characters.duplicate()
	_sort_turn_order()
	_current_turn_index = 0
	_next_turn()


func _next_turn():
	if _turn_order.size() == 0: return

	if _current_turn_index >= _turn_order.size():
		_current_turn_index = 0

	var current_character: Character = _turn_order[_current_turn_index]
	turn_started.emit(current_character)


func _on_turn_ended(_character: Character):
	if _turn_order.size() == 0: return

	_current_turn_index += 1

	if _current_turn_index >= _turn_order.size():
		_current_turn_index = 0

	_next_turn()


func _sort_turn_order():
	_turn_order.sort_custom(_sort_ascending)


# --- UTILS --- #

func _sort_ascending(a: Character, b: Character):
	if a.get_class_data_parameter('speed') > b.get_class_data_parameter('speed'):
		return true
	return false
