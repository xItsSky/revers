extends Area2D
class_name Bouton

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse = get_local_mouse_position()
	var mouse_hover = get_node("CollisionShape2D").shape.get_rect().has_point(mouse)
	#print(get_node("CollisionShape2D").shape.get_rect(), mouse, mouse_hover)
	if Input.is_action_just_pressed("card_mouse") and mouse_hover:
		#print("activate")
		activate()

func activate():
	pass
