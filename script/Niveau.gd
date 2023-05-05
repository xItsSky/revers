extends Node2D
class_name Niveau

@export var niveau_suivant:Niveau
@export var teleporteur: Teleporteur
@export var camera: Camera2D
@export var Carte_deplacement_default_verso = true
@export var Carte_element_default_verso = true
@export var player_direction_default = 0
var player:Player
var engine:LevelEngine
var level_playing = false
var animating_tp = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animating_tp:
		player.rotation_degrees = player.rotation_degrees + delta * 720
		player.modulate.a -= delta * 2
		if player.modulate.a < 0.:
			player.modulate.a = 0.
		

func launch_niveau(player_: Player, engine_: LevelEngine):
	print("launch")
	level_playing = true
	camera.make_current()
	player = player_
	engine = engine_
	engine.pause_all()
	teleporteur.callback_player_entered = win
	player.collision_death_callback = death
	init_player()
	
func init_player():
	player.default_comportement()
	player.force_position(position)
	engine.reset_cards(Carte_deplacement_default_verso, Carte_element_default_verso)
	player.set_direction(player_direction_default)
	engine._stop_animation()
	await get_tree().create_timer(0.7).timeout
	engine.awake_all()
	
func stop_niveau():
	level_playing = false

func death():
	if level_playing:
		engine.pause_all()
		await get_tree().create_timer(1.5).timeout
		init_player()

func launch_niveau_suivant():
	animating_tp = false
	teleporteur.tp_animation.animation_finished.disconnect(launch_niveau_suivant)
	niveau_suivant.launch_niveau(player, engine)

func win():
	if level_playing:
		stop_niveau()
		animating_tp = true
		engine.pause_all()
		teleporteur.tp_animation.play("tp")
		teleporteur.sound.play()
		teleporteur.tp_animation.animation_finished.connect(launch_niveau_suivant)
		player.force_position(teleporteur.position)
