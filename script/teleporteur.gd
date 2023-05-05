extends Node2D
class_name Teleporteur

var area2d: Area2D
var callback_player_entered: Callable
var tp_animation: AnimatedSprite2D
var sound: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	sound = get_node("SonTeleporteur")
	area2d = get_node("AnimatedSprite2D/Area2D")
	tp_animation = get_node("TeleporteurAnimation/AnimatedSprite2D")
	area2d.area_entered.connect(area_entered_callback)
	pass # Replace with function body.

func area_entered_callback(obj):
	if obj.get_parent().get_parent().is_in_group("Player"):
		callback_player_entered.call()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
