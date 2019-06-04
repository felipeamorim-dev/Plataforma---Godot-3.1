extends "res://Scripts/enemy.gd"

var is_alive = true

func _ready():
	add_to_group(game.ENEMY)
	pass

func _physics_process(delta):
	if is_alive:
		change_move(delta)
		test_mov_collider()
		flip_horizontal()
	 

func _dead():
	is_alive = false
	remove_from_group(game.ENEMY)
	$shape.set_deferred("disabled", true)
	$anim.play("destroy")
	yield($anim, "animation_finished")
	queue_free()
	