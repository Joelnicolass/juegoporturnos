extends Node

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
    next_turn()


func next_turn():
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

    next_turn()


func _sort_turn_order():
    _turn_order.sort_custom(sort_ascending)


func sort_ascending(a: Character, b: Character):
    if a.speed > b.speed:
        return true
    return false