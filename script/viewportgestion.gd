extends Node2D

func _ready():
	pass

func _process(delta):
	var camera = get_node("Camera2D")
	camera.position.x += delta *10
	#print(camera.position)
	
