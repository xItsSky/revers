extends Node2D
class_name Entite

@export var direction = 0
@export var rotation_default = 0
@export var distance_move = 64
var direction_names = ["NORTH", "EAST", "SOUTH", "WEST"]
var direction_rot = [0, 90, 180, 270]
var direction_vector = [Vector2i(0,-1),  Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0)]
var labyrinthe : TileMap
@export var frame_delay = 1.0
var time_from_last_frame = 0.0
var target_pos : Vector2i
var register_pos: Vector2i
var movement_predict: Vector2
var target_rot: int
var register_rot: int
var rot_predict: float
var paused = false
var electric_danger = true
@export var electric_timer_till_death = 0.2
var electric_timer = 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Entite")
	labyrinthe = get_node("../Labyrinthe")
	target_rot = rotation_default + direction_rot[direction]
	rotation_degrees = target_rot
	register_rot = target_rot
	rot_predict = 0.
	register_pos = position
	target_pos = register_pos
	movement_predict = Vector2(0,0)
	
func to_horizontal_movement():
	if direction == 0 || direction == 2:
		quart_de_tour()

func to_vertical_movement():
	if direction == 1 || direction == 3:
		quart_de_tour()

func quart_de_tour():
	direction += 1
	direction = direction % 4
	target_rot = target_rot + 90
	
func demi_tour():
	direction += 2
	direction = direction % 4
	target_rot = target_rot + 180
	
func move_once():
	register_rot = target_rot
	
	register_pos = target_pos
	target_pos = register_pos + direction_vector[direction] * distance_move
	var pos_tile = labyrinthe.local_to_map(target_pos/Vector2i(labyrinthe.scale))
	#print(pos_tile)
	#print(labyrinthe.get_layer_name(0))
	var tiledata = labyrinthe.get_cell_tile_data(0,pos_tile)
	var tiledata_air = labyrinthe.get_cell_tile_data(1,pos_tile)
	#print(tiledata)
	if tiledata != null:
		if tiledata.get_custom_data("Mur"):
			if tiledata_air != null and tiledata_air.get_custom_data("DeathCollision"):
				electric_timer = 0.
				electric_danger = true
				electric_death()
				print("elec")
			else:
				demi_tour()
				target_pos = register_pos
		#labyrinthe._tile_data_runtime_update(0, labyrinthe.local_to_map(next_pos), tiledata)
	#position = next_pos
	#print(target_pos)
	predict()

func predict():
	movement_predict = Vector2(target_pos - register_pos) / frame_delay
	rot_predict = (target_rot - register_rot) / frame_delay
	
func set_direction(dir):
	direction = dir % 4
	target_rot = rotation_default + direction_rot[direction]
	
func _process(delta):
	if paused:
		return
	time_from_last_frame += delta
	if electric_danger:
		electric_timer += delta
		if electric_timer >= electric_timer_till_death:
			electric_death()
	while time_from_last_frame > frame_delay:
		time_from_last_frame -= frame_delay
		move_once()
		check_collision()
	position = Vector2(register_pos) + time_from_last_frame * movement_predict
	rotation_degrees = round(register_rot + rot_predict * time_from_last_frame)

func _stop_animation():
	electric_danger = false
	position = target_pos
	register_pos = target_pos
	rotation_degrees = target_rot
	register_rot = target_rot
	time_from_last_frame = 0.
	predict()

func force_position(pos):
	target_pos = pos
	register_pos = pos
	electric_danger = false
	_stop_animation()

func default_comportement():
	modulate.a = 1.0

func electric_death():
	electric_danger =  false
	paused = true
	force_position(position)

func check_collision():
	pass
