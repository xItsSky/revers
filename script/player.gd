extends Entite
class_name Player

var state_list  = ["default", "red", "blue"]
var state = 0
var animated_sprite: AnimatedSprite2D
var collision_death_callback:Callable
var death_animation = false
var elec_animation = false
var elec_timing = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	animated_sprite = get_node("AnimatedSprite2D")
	add_to_group("Player")
	change_sprite()


func change_sprite():
	animated_sprite.play(state_list[state])

func to_blue():
	state =  1
	change_sprite()

func to_red():
	state =  2
	change_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if elec_animation:
		elec_timing += delta
		if elec_timing / frame_delay < 0.3:
			position += direction_vector[direction] * delta * distance_move / frame_delay
	
	
func check_collision():
	var collision = false
	var pos_tile = labyrinthe.local_to_map(register_pos/Vector2i(labyrinthe.scale))
	#print(pos_tile)
	#print(labyrinthe.get_layer_name(0))
	var tiledata = labyrinthe.get_cell_tile_data(1,pos_tile)
	#print(tiledata)
	if tiledata != null:
		if tiledata.get_custom_data("Fire") && state != 1:
			collision = true
		if tiledata.get_custom_data("Fire") && state == 1:
			#get_node("Fire").play()
			pass
		if tiledata.get_custom_data("Water") && state != 2:
			collision = true
			
	if collision:
		get_node("Dead").play()
		death_animation = true
		force_position(register_pos)
		animated_sprite.stop()
		if collision_death_callback != null:
			collision_death_callback.call()

func default_comportement():
	super.default_comportement()
	get_node("ElecAnim").animation = "default"
	elec_animation = false
	get_node("Electricity").stop()
	get_node("Dead").stop()
	get_node("Fire").stop()
	get_node("Water").stop()
	animated_sprite.play()
	death_animation = false

func electric_death():
	super.electric_death()
	collision_death_callback.call()
	get_node("ElecAnim").play("elec")
	elec_animation = true
	death_animation = true
	elec_timing = 0.0
	#target_pos = position + direction_vector[direction] * 0.3
	get_node("Electricity").play()
	#get_node("Dead").play()
	
