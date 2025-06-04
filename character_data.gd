extends Resource
class_name CharacterData

# nombre del personaje
@export var name: String = "Character"
# descripción del personaje
@export var description: String = "A character in the game."
# puntos para poder atacar
@export var skill_points: int = 0
# salud del personaje
@export var health: int = 0
# puntos de ataque
@export var attack: int = 0
# puntos de defensa
@export var defense: int = 0
# puntos de velocidad
@export var speed: int = 0
# puntos de magia
@export var magic: int = 0
# puntos de suerte
@export var luck: int = 0
# puntos de experiencia
@export var experience: int = 0
# probabilidad de critico
@export var critical_chance: float = 0.0
# nivel del personaje
@export var level: int = 1
# mesh del personaje (color para debuggear)
@export var color: Color = Color(1, 1, 1)