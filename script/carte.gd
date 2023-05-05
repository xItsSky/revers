extends Node2D
class_name Carte

@export var action_input_name = "card_1"
@export var verso = true
var callback_verso: Callable
var callback_recto: Callable
var ready_to_activate = true
var animated_sprite:AnimatedSprite2D
var mouse_hove = false
var area2d : Shape2D
var paused = false

#func set_callbacks(callback_v: Callable, callback_r: Callable):
	#callback_recto = callback_r
	#callback_verso = callback_v
func activate_callback(play_anim = true):
	if verso:
		callback_verso.call()
		if play_anim:
			animated_sprite.play("verso")
	else:
		callback_recto.call()
		if play_anim:
			animated_sprite.play("recto")
			
func activate():
	if ready_to_activate:
		ready_to_activate = false
		verso = !verso
		activate_callback()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#sprite_frames = ResourceLoader.load(animation_sprites)
	animated_sprite = get_node("AnimatedSprite2D")
	animated_sprite.animation_finished.connect(set_ready)
	animated_sprite.animation = "recto" if verso else "verso"
	add_to_group("Carte_1")
	area2d = get_node("AnimatedSprite2D/Area2D/CollisionShape2D").shape
	
func set_ready():
	ready_to_activate = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if paused:
		return
	var mouse = get_local_mouse_position()
	var mouse_hover = area2d.get_rect().has_point(mouse)
	if Input.is_action_just_pressed(action_input_name):
		activate()
	if Input.is_action_just_pressed("card_mouse") and mouse_hover:
		activate()

func set_verso(verso_bool):
	verso = verso_bool
	animated_sprite.animation = "recto" if verso_bool else "verso"
	animated_sprite.frame = 0

