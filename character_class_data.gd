extends Resource
class_name CharacterClassData

# nombre del personaje
@export var name: String = "Character class"
# descripción del personaje
@export var description: String = "A character class in the game."
# puntos para poder atacar
@export var skill_points: int = 0
# salud del personaje
@export var health: float = 0.0
# puntos de ataque
@export var attack: float = 0.0
# puntos de defensa
@export var defense: float = 0.0
# puntos de velocidad
@export var speed: float = 0.0
# puntos de magia
@export var magic: float = 0.0
# puntos de suerte
@export var luck: float = 0.0
# puntos de experiencia
@export var experience: float = 0.0
# probabilidad de critico
@export var critical_chance: float = 0.0
# nivel del personaje
@export var level: int = 1
# mesh del personaje (color para debuggear)
@export var color: Color = Color(1, 1, 1)