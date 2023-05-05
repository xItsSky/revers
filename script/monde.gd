extends TileMap
class_name Monde

@export var niveau_1: Niveau
@export var player_1: Player
@export var engine: LevelEngine

# Called when the node enters the scene tree for the first time.
func _ready():
	niveau_1.launch_niveau.call_deferred(player_1, engine)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
