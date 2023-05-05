extends Node2D
class_name LevelEngine

@export var frame_delay = 1.0
var time_from_last_frame = 0.0
var entite_list = []
var players = []
@export var carte_deplacement:Carte
@export var carte_elements:Carte
@export var carte_3:Carte


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.is_in_group("Entite"):
			entite_list.append(child)
		if child.is_in_group("Player"):
			players.append(child)
	if carte_deplacement != null:
		carte_deplacement.callback_verso = activate_verso_deplacement
		carte_deplacement.callback_recto = activate_recto_deplacement
		carte_deplacement.activate_callback(false)
	if carte_elements != null:
		carte_elements.callback_recto = activate_recto_elements
		carte_elements.callback_verso = activate_verso_elements
		carte_elements.activate_callback(false)
	pause_all()

func activate_recto_elements():
	for e in players:
		e.to_red()
		
func activate_verso_elements():
	for e in players:
		e.to_blue()
		
func activate_recto_deplacement():
	for e in players:
		e.to_vertical_movement()

func activate_verso_deplacement():
	for e in players:
		e.to_horizontal_movement()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("skip"):
		get_node("NiveauFinal/spawner_niveau").launch_niveau(players[0], self)
	pass
			
func reset_cards(carte_deplacement_verso:bool, carte_element_verso:bool):
	if carte_deplacement != null:
		carte_deplacement.set_verso(carte_deplacement_verso)
		#carte_deplacement.activate_callback(false)
	if carte_elements != null:
		carte_elements.set_verso(carte_element_verso)
		carte_elements.activate_callback(false)

func _stop_animation():
	for e in entite_list:
		e._stop_animation()

func pause_all():
	for e in entite_list:
		e.paused = true
	if carte_deplacement != null:
		carte_deplacement.paused = true
	if carte_elements != null:
		carte_elements.paused = true
	get_node("RobotSound").stop()

func awake_all():
	for e in entite_list:
		e.paused = false
	if carte_deplacement != null:
		carte_deplacement.paused = false
	if carte_elements != null:
		carte_elements.paused = false
	get_node("RobotSound").play()
