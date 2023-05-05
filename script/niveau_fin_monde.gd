extends Niveau
class_name NiveauFinMonde

@export var NomSceneNext = "res://scene/monde2LevelDesign.tscn"
@export var Booster:Node2D

func launch_niveau(player_: Player, engine_: LevelEngine):
	camera.make_current()
	player = player_
	engine = engine_
	engine.pause_all()
	if Booster != null:
		var anim = Booster.get_child(0)
		anim.play("booster")
		await get_tree().create_timer(1.0).timeout
		anim.play("opening")
		await get_tree().create_timer(2.5).timeout
		anim.play("end")
		await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(NomSceneNext)
